/**
* @author           Kalaiselvi R
* @version          1.0 
* @date             13-Oct-2017
* @Status           Developed
* @description      This is the controller class to fetch sentimental score from algorithmia sentiment analysis (third pary tool).
*                   The class will be called from trigger named EZRE_ContactActivityDateUpdate. 
*                   If incase algorithmia tool credit limit exceeds then, we need to upgrade by paying money. exsiting account credentials is below,
*                   user name = kalaiselvi password = Prelude@123.
*                   we also can create new account, if we are creating new account then dont use default API Key, instead create custom API key and replace it in line no 29. 
*/
global class EZRE_AlgorithmiaToolIntegration {
      
    //Hit algorithmia tool and get sentiment score for the ezre contacts activity. pass this score to activity trigger
    @future(callout=true)
    global static void InvokeAlgorithmiaApi(set<Id> taskIds)
    {
        List<Task> updateTaskLst = new List<Task>();
        try {
            List<Task> taskLst = EZRE_Requirement_DataUtility.fetchTaskById(taskIds, 'ODS Call 1');
            if(taskLst.size() > 0)  {
                for(task tsk : taskLst) {
                    String sentimentScore;
                    
                    //to replace all the special char by space and send it to sentiment analysis
                    string comments =  tsk.description.replaceAll('[^a-zA-Z0-9]', ' ');
                    HTTPResponse response = new HTTPResponse();
                    Http http = new Http();
                    string APIKey = label.Algorithmia_API_Key;
                    string endPointURL = 'https://api.algorithmia.com/v1/algo/nlp/SentimentAnalysis/1.0.4';

                    HttpRequest request = new HttpRequest();
                    request.setHeader('Connection','keep-alive');
                    request.setHeader('Content-Type','application/json');
                    request.setHeader('Authorization', APIKey);
                    request.setEndpoint(endPointURL);
                    request.setBody('{ "document": "'+comments +'"}');
                    request.setMethod('POST');

                    string resBody = '';
                    if(!Test.isrunningtest())    {
                        response = http.send(request);
                        resBody = response.getBody();
                    }
                    // mock resonpse for test class
                    else
                        resBody = '{"result":[{"document":"ODS Call notes on paper will update here","sentiment":0}]}';
                       
                    Map<String,Object> jsonResp = (Map<String,Object>) JSON.deserializeUntyped(resBody );
                    List<Object> responseResultLst = (List<Object>)jsonResp.get('result');
                    Map<String,Object> Result = new Map<String,Object>();

                    if(responseResultLst != null)    {
                        for(Object obj: responseResultLst)    {
                            Result=(Map<String,Object>) obj; 
                            sentimentScore = string.valueOf(Result.get('sentiment'));
                            Task objTask = new Task(id = tsk.id);
                            objTask.Sentiment_Score__c = sentimentScore;
                            updateTaskLst.add(objTask);
                        }
                    }
                }
           }
           update updateTaskLst;
        } catch (Exception ex){
            System.debug(ex);
        }
    }
}