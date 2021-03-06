import 'package:bt_core/core.dart';
import 'package:test/test.dart';

void main() {
  test("rune type from code", () {
    expect(runeTypeFromCode(':'.codeUnits[0]), equals(RuneType.COLON));
    expect(runeTypeFromCode('l'.codeUnits[0]), equals(RuneType.L));
    expect(runeTypeFromCode('d'.codeUnits[0]), equals(RuneType.D));
    expect(runeTypeFromCode('i'.codeUnits[0]), equals(RuneType.I));
    expect(runeTypeFromCode('e'.codeUnits[0]), equals(RuneType.E));
    expect(runeTypeFromCode("-".codeUnits[0]), equals(RuneType.SIGN));
    List.generate(10, (index) => index.toString()).forEach((code) {
      expect(runeTypeFromCode(code.codeUnits[0]), equals(RuneType.DIGIT));
    });
  });
  test("string decode", () {
    expect(decodeString(RuneIterator.at("8:announce", 0)..moveNext()),
        equals("announce"));
    expect(decodeString(RuneIterator.at("8:announcee", 0)..moveNext()),
        equals("announce"));
  });
  test("string decode iter position", () {
    RuneIterator iter = RuneIterator.at("8:announcee", 0)..moveNext();
    decodeString(iter);
    expect(iter.current, "e".codeUnits[0]);
  });
  test("int decode", () {
    expect(decodeInt(RuneIterator.at("i0e", 0)..moveNext()), equals(0));
    expect(decodeInt(RuneIterator.at("i1e", 0)..moveNext()), equals(1));
    expect(decodeInt(RuneIterator.at("i123123123123e", 0)..moveNext()),
        equals(123123123123));
    expect(decodeInt(RuneIterator.at("i-123234234e", 0)..moveNext()),
        equals(-123234234));
  });
  test("int decode iter position", () {
    RuneIterator iter = RuneIterator.at("i234ek", 0)..moveNext();
    decodeInt(iter);
    expect(iter.current, "k".codeUnits[0]);
  });
  test("list decode", () {
    expect(decodeList(RuneIterator.at("l3:abci123ee", 0)..moveNext()),
        equals(["abc", 123]));
    expect(decodeList(RuneIterator.at("li123e3:abce", 0)..moveNext()),
        equals([123, "abc"]));
    expect(decodeList(RuneIterator.at("li123ei123ee", 0)..moveNext()),
        equals([123, 123]));
    expect(decodeList(RuneIterator.at("l3:abc3:abce", 0)..moveNext()),
        equals(["abc", "abc"]));
  });
  test("list decode iter position", () {
    RuneIterator iter = RuneIterator.at("l3:abci123eeq", 0)..moveNext();
    decodeList(iter);
    expect(iter.current, "q".codeUnits[0]);
  });
  test("dict decode", () {
    expect(
        decodeDict(
            RuneIterator.at("d4:name11:create chen3:agei23ee", 0)..moveNext()),
        equals({"name": "create chen", "age": 23}));

    expect(
        decodeDict(RuneIterator.at("d4:namel13:create chennne3:agei23ee", 0)
          ..moveNext()),
        equals({
          "name": ["create chennn"],
          "age": 23
        }));
  });
  test("dict decode iter position", () {
    RuneIterator iter = RuneIterator.at("d4:name11:create chen3:agei23eeq", 0)
      ..moveNext();
    decodeDict(iter);
    expect(iter.current, "q".codeUnits[0]);
  });
}
