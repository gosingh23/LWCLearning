public class RuleEvaluator {
    public static String logicalExpression;
    public static Map<String, Boolean> valueMap;
    
    /****
	 * 
	 */
    public RuleEvaluator(String logicalExpression, Map<String, Boolean> valueMap) {        
        evaluate(logicalExpression);
    }
    
	/****
	 * 
	 */
    static Boolean checkStringFormat(String formula) {
        if(string.isBlank(formula)) return false; // TODO: Return 'EvaluationResult' type?
        
        formula = formula.toUpperCase().remove(' ').trim();

        Integer bracesCount = 0;
        Boolean positiveBraceCount = false;
        
        for (Integer i = 1; i <= formula.length(); i++ ) {
            String s = formula.substring(i-1,i);
            if (s == ')') {
                bracesCount--;
                if (bracesCount < 0) return false; // TODO: Return 'EvaluationResult' type?
            } else if (s == '(') {
                bracesCount++;
                positiveBraceCount = true;
                if (!(formula.substring(i-3,i-1) == 'OR'|| formula.substring(i-4,i-1) == 'NOT' || formula.substring(i-4,i-1) == 'AND')) {
                    return false; // TODO: Return 'EvaluationResult' type?
                }
            }
        }
        return bracesCount == 0 && positiveBraceCount;
    }
    
    /****
	 * 
	 */
    static Integer findEndIndex(String formula) {
        integer bracesCount = 0;
        for (Integer i = 1; i <= formula.length(); i++ ) {
            if (formula.substring(i-1,i) == '(') {
                bracesCount++;
            } else if (formula.substring(i-1,i) == ')') {
                bracesCount--;
                if (bracesCount == 0) return i-1;
            }
        }
        
        return 0; //TODO: returning 0 may lead into recursion if not handled 
    }
	
    /****
	 * 
	 *
    static void braceCount(String formula) {
        integer bracesCount = -1;
        for (integer i = 1; i <= formula.length(); i++ ) {
            if (formula.substring(i-1,i)=='(') {
                bracesCount++;
            } else if (formula.substring(i-1,i)==')') {
                bracesCount--;
            }
            
        }
    }
	*/
    
    /****
	 * 
	 */
    public Expression evaluate(String formula) {
        Expression result;
        
        if (RuleEvaluator.checkStringFormat(formula)) result = new Evaluator().evaluate(formula, true, null);
        system.debug('result: '+result);
        system.debug('result: '+result.evaluate());
        return result;
    }
    
    public class EvaluationResult {
        Boolean isError;
        Boolean result;
        String errorMessage;
        
    }

    class Evaluator {

        /****
         * 
         */
        private Expression evaluate(String formula, Boolean isTopLevel, String prevExp) {
            system.debug('Formula: '+formula);
            formula = formula.toUpperCase(); // TODO: move outside method ? 
            formula = formula.trim();
            formula = formula.remove(' ');
            
            Expression expr;
            
            if (isTopLevel) {
                if (formula.startsWith('AND')) {
                    expr = new Evaluator().evaluate(formula.substring(4,formula.length()-1), false, 'AND');
                } else if (formula.startsWith('OR')) {
                    expr = new Evaluator().evaluate(formula.substring(3,formula.length()-1), false, 'OR');
                }
                //expr.evaluate();
            } else {
                List<String> elements = new ElementsUtility().splitElements(formula);
                system.debug('Evaluating elements: '+elements);

                if (prevExp == 'AND') {
                    expr = new AndComposite();
                } else if (prevExp == 'OR'){
                    expr = new OrComposite();
                }

                for (String s : elements) {
                    system.debug('this Element: '+s);
                    if (s.startsWith('AND')) {
                        expr.add(new Evaluator().evaluate(s.substring(4,s.length()-1), false, 'AND'));
                        system.debug('expr AND: '+expr);
                    } else if (s.startsWith('OR')) {
                        expr.add(new Evaluator().evaluate(s.substring(3,s.length()-1), false, 'OR'));
                        system.debug('expr OR: '+expr);
                    } else {
                        system.debug('expr before: '+expr);
                        for (String e : s.split(',')) {
                            system.debug('this var: '+e);
                            //system.debug(valueMap);
                            system.debug('this Value: '+valueMap.get(e));
                            //system.debug(new Variable(valueMap.get(e)));
                        	//expr.add(new Variable(valueMap.get(e)));
                        	expr.add(new Variable(e).set(e,valueMap.get(e)));
                        }
                        system.debug('expr after: '+expr);
                    }
                }
            }
            
            return expr;
        }
    }

    class ElementsUtility {
        List<String> elements = new List<String>();

        /****
         * 
         */
        List<String> splitElements(String formula) {
            system.debug('String to check: '+formula);
            if (formula.startsWith('AND') || formula.startsWith('OR')) {
                Integer endIndex = RuleEvaluator.findEndIndex(formula);
                //system.debug('endIndex: '+endIndex);
                //system.debug('formula.length(): '+formula.length());
                String newElement;
                if (endIndex < formula.length()-1) {
                    newElement = formula.substring(0,endIndex+1);
                    system.debug('newElement: '+newElement);
                	elements.add(newElement);
                    this.splitElements(formula.substring(endIndex+2));
                } else {
                    system.debug('newElement: '+formula);
                    elements.add(formula);
                }
            } else {
                String newElement = formula.substring(0,1); // TODO: support value after 9 .. 
                system.debug('newElement: '+newElement);
                elements.add(newElement);
                //system.debug('newElement: '+newElement);
                //system.debug('endString: '+formula.substring(1));
                if (!String.isBlank(formula.substring(1))) this.splitElements(formula.substringAfter(','));
            }
            //system.debug('Elements: '+elements);
            return elements;
        }
    }
}