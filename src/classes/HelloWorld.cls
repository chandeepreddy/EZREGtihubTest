global class HelloWorld implements SandboxPostCopy {
  global void runApexClass(SandboxContext context) {
      System.debug('Hello Tester Pester ' + context.organizationId()
           + ' ' + context.sandboxId() + context.sandboxName());
    }
  }