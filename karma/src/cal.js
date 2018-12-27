function cal(op1,op2,optype){
    if ( optype === 'add' ) {
      return op1 + op2;
    } else if ( optype === 'sub' ) {
      return op1 - op2;
    } else if ( optype === 'mul' ) {
      return op1 * op2;
    } else if ( optype === 'div' ) {
      return op1 / op2;
    }
}
