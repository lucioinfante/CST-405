// ---- Functions to handle IR code emissions ---- //

FILE* IRcode;

void  initIRcodeFile(){
    IRcode = fopen("IRcode.ir", "a");
}

void emitBinaryOperation(char op[1], const char* id1, const char* id2){
    fprintf(IRcode, "T1 = %s %s %s", id1, op, id2);
}

void emitAssignment(char * id1, char * id2){
  // Option 1
  // fprintf(IRcode, "%s = %s\n", id1, id2);

  // Option 2
  fprintf(IRcode, "T1 = %s\n", id1);
  fprintf(IRcode, "T2 = %s\n", id2);
  fprintf(IRcode, "T2 = T1\n");
}

void emitConstantIntAssignment (char id1[50], char id2[50]){
    fprintf(IRcode, "%s = %s\n", id1, id2);
}

void emitWriteId(char * id){
    //fprintf (IRcode, "output %s\n", id); // This is the intent... :)

    // This is what needs to be printed, but must manage temporary variables
    // We hardcode T2 for now, but you must implement a mechanism to tell you which one...
    fprintf (IRcode, "output %s\n", "T2");
}