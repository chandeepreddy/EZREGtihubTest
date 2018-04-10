public Class isRecursiveAccountTrigger{
    private static boolean run = true;
    public static boolean firedfromAccountTrigger= true;
    public static boolean runOnce(){
       if(run){
           run=false;
           return true;
       }
       else{
           return run;
       }
    }
    public static void firedfromAccount(){
        firedfromAccountTrigger= false;
    }
}