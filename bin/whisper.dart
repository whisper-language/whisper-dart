import 'package:antlr4/antlr4.dart';

import 'BuildInFunction.dart';
import 'EvalVisitor.dart';
import 'Scope.dart';
import 'TLValue.dart';
import 'gen/WhisperLanguageLexer.dart';
import 'gen/WhisperLanguageParser.dart';

class sum implements BuildInFunction {
  @override
  TLValue invoke(List<TLValue> argv) {
    var s = 0.0;
    argv.forEach((element) {
      s += element.value;
    });
    return TLValue(v: s);
  }
}

void main(List<String> arguments) {
  var a = InputStream.fromPath('case/main.whl');
  a.then((value) {
    var lexer = WhisperLanguageLexer(value);
    var parser = WhisperLanguageParser(CommonTokenStream(lexer));
    parser.buildParseTree = true;
    ParseTree tree = parser.parse();
    var functions = {};
    functions['@sum'] = sum();
    var visitor = EvalVisitor(Scope(null, false), {}, functions);
    visitor.visit(tree);
  });
}
