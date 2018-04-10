/**
 * @author           Kalaiselvi R
 * @version          1.0 
 * @date             21/07/2016
 * @Status           Developed
 * @description      This class is used to avoid firing EZRE_ActivityContactUpdate and 
 *                   GoogleAlertToChatterStatusChange Triggers when Task is created in
 *                   the EZRE_MC_MarketingEmail. Both the Triggers will fire all other times.
 *
 */

public class EZRE_RecursionCheck
{
    public static boolean isFutureUpdate;
    
    /*Boolean shouldIRun = true;
       
    public Boolean canIRun(){
         return shouldIRun;
    }
    public void stopRecursion(){
        shouldIrun = false;
    }
    public void allowTorun(){
        shouldIRun = true;
    }*/
}