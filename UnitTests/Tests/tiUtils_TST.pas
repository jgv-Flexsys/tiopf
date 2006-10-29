unit tiUtils_TST;

{$I tiDefines.inc}

interface
uses
  Classes  // needed for TStringList
  {$IFDEF FPC}
  ,testregistry
  {$ELSE}
  ,TestFrameWork
  {$ENDIF}
  ,tiTestFramework
  ,math
 ;

const
  cINIMachineSettings = 'MachineSettings';

type

  { TTestTIUtils }

  TTestTIUtils = class(TtiTestCase)
  private
    function  BuildLongString : string;
    procedure CheckReadingFromNT(const AValue, pRegKey, pDescription : string);
  protected
    // These methods exist in tiUtils, but have not been DUnit tested because
    // I can not work our a reliable way of performing the tests (or I don't
    // have currently have a use for the method so the test is not a priority!)

    // Difficult to test
    // procedure _tiShellExecute;
    // procedure tiRunEXEAndWait;
    // procedure tiShellExecute;
    // procedure tiGetEXEPath; Tricky to test because it must work for both an EXE and a DLL (ISAPI DLL)

    // Low priority
    // procedure tiBitToString; // Have not used this for a long time, so implement DUnit test when required again
    // procedure tiInt32ToBinString; // Have not used this for a long time, so implement DUnit test when required again
    // procedure tiIsBitSet; // Have not used this for a long time, so implement DUnit test when required again

    procedure TearDown; override;
  published
//    procedure tiDateToStr;
//    procedure tiDirectoryTreeToStringList;
//    procedure tiExtractDirToLevel;
//  protected
    procedure tiForceRemoveDir; // Must be one of the first things tested as it's used in TearDown

    procedure _tiFloatToStr;
    procedure Cr;
    procedure CrLf;
    procedure Lf;
    procedure TestCreateDir;     // Tests logic used in tiFileToStringList test
    procedure TestCreateFile;    // Tests logic used in tiFileToStringList test
    procedure tiAddEllipsis;
    procedure tiAddTrailingAnd;
    procedure tiAddTrailingComma;
    procedure tiAddTrailingOr;
    procedure tiAddTrailingSlash;
    procedure tiAddTrailingSpace;
    procedure tiAddTrailingValue;
    procedure tiAppendStringToStream;
    procedure tiAusFinancialYearToString;
    procedure tiBooleanToStr;
    procedure tiCheckSum;
    procedure tiCIStrTran;
    procedure tiCopyFile;
    procedure tiCopyStream;
    procedure tiDateTimeAsIntlDateDisp;
    procedure tiDateTimeAsIntlDateStor;
    procedure tiDateTimeToStr;
    procedure tiDateToAusFinancialYear;
    procedure tiDateToPreviousWeekDayDate;
    procedure tiDateToStr;
    procedure tiDateWithinRange;
    procedure tiDeleteFiles;
    procedure tiDirectoryTreeToStringList;
    procedure tiEncodeDecodeWordBase26;
    procedure tiExtractDirToLevel;
    procedure tiExtractExtension;
    procedure tiExtractFileNameOnly;
    procedure tiFilesToStringList;
    procedure tiFileToStream;
    procedure tiFileToString;
    procedure tiFixPathDelim_Test;
    procedure tiFloatToCommaStr;
    procedure tiFloatToCurrency;
    procedure tiFloatToCurrencyHide0;
    procedure tiFloatToStr;
    procedure tiForceDirectories;
    procedure tiGetComputerName;
    procedure tiGetFileSize;
    procedure tiGetTempDir;
    procedure tiGetTempFile;
    procedure tiGetUserName;
    procedure tiGetWindowsSysDir;
    procedure tiHasRTTIOnClass;
    procedure tiHasRTTIOnObject;
    procedure tiHasSubDirectory;
    procedure tiIfInteger;
    procedure tiIfReal;
    procedure tiIfString;
    procedure tiInsertStringToStream;
    procedure tiIntegerList;
    procedure tiIntlDateDispAsDateTime;
    procedure tiIntlDateStorAsDateTime;
    procedure tiIntToCommaStr;
    procedure tiIntToStrHide0;
    procedure tiIsEMailAddressValid;
    procedure tiIsFileNameValid;
    procedure tiIsFileReadOnly;
    procedure tiIsNearEnough;
    procedure tiIsVariantOfType;
    procedure tiJoinPath;
    procedure tiListToClipboardDefault;
    procedure tiListToClipboardFields;
    procedure tiListToCSVDefault;
    procedure tiListToCSVFields;
    procedure tiListToStreamDefault;
    procedure tiListToStreamDelims;
    procedure tiListToStreamFields;
    procedure tiMixedCase;
    procedure tiMoveFile;
    procedure tiNormalizeStr;
    procedure tiNumToken;
    procedure tiPad0;
    procedure tiPadC;
    procedure tiPadL;
    procedure tiPadR;
    procedure tiPosR;
    procedure tiReadFileDateSize;
    procedure tiRemoveCrLf;
    procedure tiRemoveDirectory;
    procedure tiRemoveDrive;
    procedure tiRemoveExtension;
    procedure tiRemoveLeading0;
    procedure tiRemoveLeadingSlash;
    procedure tiRemoveTrailingSlash;
    procedure tiRemoveTrailingValue;
    procedure tiReplicate;
    procedure tiRound;
    procedure tiSafeDiv;
    procedure tiSetFileDate;
    procedure tiSetFileReadOnly;
    procedure tiSetPrecision;
    procedure tiSpace;
    procedure tiStreamToFile;
    procedure tiStreamToString1;
    procedure tiStreamToString2;
    procedure tiStringToFile;
    procedure tiStringToStream;
    procedure tiStrPos;
    procedure tiStrToBool;
    procedure tiStrToFloat;
    procedure tiStrToInt;
    procedure tiStrTran;
    procedure tiStrTran1;
    procedure tiSubStr;
    procedure tiSwapExt;
    procedure tiTestStreamsIdentical;
    procedure tiTimeToStr;
    procedure tiToken;
    procedure tiTrimL;
    procedure tiTrimR;
    procedure tiTrimTrailingWhiteSpace;
    procedure tiVariantArrayToString;
    procedure tiWildcardMatch;
    procedure tiXCopy;
    procedure tiYear;
    procedure tiYearToEndAusFinancialYear;
    procedure tiYearToStartAusFinancialYear;
  end;
  

procedure RegisterTests;

implementation
uses
  tiUtils
  ,tiLog
  ,tiConstants
  ,tiDialogs
  {$IFDEF MSWINDOWS}
  ,tiWin32
  ,Windows
  {$ENDIF}
  ,tiDUnitDependencies
//  ,tiObject
  ,tstPerFramework_BOM
  ,tiDUnitUtils
  ,tiDUnitINI
  ,SysUtils
  {$IFDEF DELPHI6ORABOVE}
  ,Variants
  {$ELSE}
  ,FileCtrl
  {$ENDIF}
  ,TypInfo
//  ,Contnrs
  ,ClipBrd
  ,Forms
  ,DateUtils
 ;

procedure RegisterTests;
begin
  RegisterNonPersistentTest(TTestTIUtils);
end;


procedure TTestTIUtils.tiStrTran;
begin
  CheckEquals('one two three', tiUtils.tiStrTran('one two three', 'ONE', 'a'),     'Failed test 1');
  CheckEquals('a two three',   tiUtils.tiStrTran('one two three', 'one', 'a'),     'Failed test 2');
  CheckEquals('one b three',   tiUtils.tiStrTran('one two three', 'two', 'b'),     'Failed test 3');
  CheckEquals('one two c',     tiUtils.tiStrTran('one two three', 'three', 'c'),   'Failed test 4');
  CheckEquals('d d two three', tiUtils.tiStrTran('one one two three', 'one', 'd'), 'Failed test 5');
  CheckEquals('one e three e', tiUtils.tiStrTran('one two three two', 'two', 'e'), 'Failed test 6');
end;


procedure TTestTIUtils.tiStrTran1;
begin
  CheckEquals('one two three', tiUtils.tiStrTran1('one two three', 'ONE', 'a'),     'Failed test 1');
  CheckEquals('a two three',   tiUtils.tiStrTran1('one two three', 'one', 'a'),     'Failed test 2');
  CheckEquals('one b three',   tiUtils.tiStrTran1('one two three', 'two', 'b'),     'Failed test 3');
  CheckEquals('one two c',     tiUtils.tiStrTran1('one two three', 'three', 'c'),   'Failed test 4');
  CheckEquals('d d two three', tiUtils.tiStrTran1('one one two three', 'one', 'd'), 'Failed test 5');
  CheckEquals('one e three e', tiUtils.tiStrTran1('one two three two', 'two', 'e'), 'Failed test 6');
end;


procedure TTestTIUtils.tiCIStrTran;
begin
  Check(tiUtils.tiCIStrTran('one two three', 'ONE', 'a') = 'a two three', 'Failed test 1');
  Check(tiUtils.tiCIStrTran('one two three', 'TWO', 'b') = 'one b three', 'Failed test 2');
  Check(tiUtils.tiCIStrTran('one two three', 'THREE', 'c') = 'one two c', 'Failed test 3');
  Check(tiUtils.tiCIStrTran('one two three', 'one', 'a') = 'a two three', 'Failed test 4');
  Check(tiUtils.tiCIStrTran('one two three', 'two', 'b') = 'one b three', 'Failed test 5');
  Check(tiUtils.tiCIStrTran('one two three', 'three', 'c') = 'one two c', 'Failed test 6');
end;


procedure TTestTIUtils.tiNumToken;
begin
  CheckEquals(0, tiUtils.tiNumToken('', ','), 'Failed on 1');
  CheckEquals(1, tiUtils.tiNumToken('adf adf', ','), 'Failed on 2');
  CheckEquals(2, tiUtils.tiNumToken('adf,', ','), 'Failed on 3');
  CheckEquals(2, tiUtils.tiNumToken('adf,adf', ','), 'Failed on 4');
  CheckEquals(3, tiUtils.tiNumToken('adf,adf,adf', ','), 'Failed on 5');
end;


procedure TTestTIUtils.tiToken;
begin
  CheckEquals('', tiUtils.tiToken('', ',', 1), 'Failed on 1');
  CheckEquals('a', tiUtils.tiToken('a,b,c', ',', 1), 'Failed on 2');
  CheckEquals('b', tiUtils.tiToken('a,b,c', ',', 2), 'Failed on 3');
  CheckEquals('c', tiUtils.tiToken('a,b,c', ',', 3), 'Failed on 4');
  CheckEquals('', tiUtils.tiToken('a,b,c', ',', 4), 'Failed on 5');
  CheckEquals('aa', tiUtils.tiToken('aa,bb,cc', ',', 1), 'Failed on 6');
  CheckEquals('bb', tiUtils.tiToken('aa,bb,cc', ',', 2), 'Failed on 7');
  CheckEquals('cc', tiUtils.tiToken('aa,bb,cc', ',', 3), 'Failed on 8');
  CheckEquals('', tiUtils.tiToken('aa,bb,cc', ',', 4), 'Failed on 9');
end;


procedure TTestTIUtils.tiSpace;
begin
  CheckEquals('', tiUtils.tiSpace( 0), 'Failed on  0');
  CheckEquals(' ', tiUtils.tiSpace( 1), 'Failed on  1');
  CheckEquals('  ', tiUtils.tiSpace( 2), 'Failed on  2');
  CheckEquals('     ', tiUtils.tiSpace( 5), 'Failed on  5');
  CheckEquals('          ', tiUtils.tiSpace(10), 'Failed on 10');
end;


procedure TTestTIUtils.tiPadR;
begin
  CheckEquals('x', tiUtils.tiPadR('x', 1), 'Failed on 1');
  CheckEquals('x ', tiUtils.tiPadR('x', 2), 'Failed on 2');
  CheckEquals('x  ', tiUtils.tiPadR('x', 3), 'Failed on 3');
  CheckEquals('abc', tiUtils.tiPadR('abc', 3), 'Failed on 4');
  CheckEquals('ab', tiUtils.tiPadR('abc', 2), 'Failed on 5');
  CheckEquals('a', tiUtils.tiPadR('abc', 1), 'Failed on 6');
end;


procedure TTestTIUtils.tiPadL;
begin
  CheckEquals('x', tiUtils.tiPadL('x', 1), 'Failed on 1');
  CheckEquals(' x', tiUtils.tiPadL('x', 2), 'Failed on 2');
  CheckEquals('  x', tiUtils.tiPadL('x', 3), 'Failed on 3');
  CheckEquals('abc', tiUtils.tiPadL('abc', 3), 'Failed on 4');
  CheckEquals('bc', tiUtils.tiPadL('abc', 2), 'Failed on 5');
  CheckEquals('c', tiUtils.tiPadL('abc', 1), 'Failed on 6');
end;


procedure TTestTIUtils.tiPadC;
begin
  CheckEquals('x', tiUtils.tiPadC('x', 1), 'Failed on 1');
  CheckEquals('x ', tiUtils.tiPadC('x', 2), 'Failed on 2');
  CheckEquals(' x ', tiUtils.tiPadC('x', 3), 'Failed on 3');
  CheckEquals(' x  ', tiUtils.tiPadC('x', 4), 'Failed on 4');
  CheckEquals('  x  ', tiUtils.tiPadC('x', 5), 'Failed on 5');
  CheckEquals('xx', tiUtils.tiPadC('xx', 2), 'Failed on 6');
  CheckEquals('xx ', tiUtils.tiPadC('xx', 3), 'Failed on 7');
  CheckEquals(' xx ', tiUtils.tiPadC('xx', 4), 'Failed on 8');

  try
    tiUtils.tiPadC('xx', 1);
    Check(false, 'Exception was not raised');
  except
    // Do nothing
  end;
end;


procedure TTestTIUtils.tiPad0;
begin
  CheckEquals('1', tiUtils.tiPad0('1', 1), 'Failed on 1');
  CheckEquals('01', tiUtils.tiPad0('1', 2), 'Failed on 2');
  CheckEquals('001', tiUtils.tiPad0('1', 3), 'Failed on 3');
  CheckEquals('000', tiUtils.tiPad0('', 3), 'Failed on 4');
  // Perhaps not what you would expect, but anyway...
  CheckEquals('123',   tiUtils.tiPad0('1234', 3), 'Failed on 1');
end;


procedure TTestTIUtils.tiRemoveLeading0;
begin
  CheckEquals('', tiUtils.tiRemoveLeading0('0'), 'Failed on 1');
  CheckEquals('', tiUtils.tiRemoveLeading0('00'), 'Failed on 2');
  CheckEquals('123', tiUtils.tiRemoveLeading0('123'), 'Failed on 3');
  CheckEquals('123', tiUtils.tiRemoveLeading0('0123'), 'Failed on 4');
  CheckEquals('123', tiUtils.tiRemoveLeading0('00123'), 'Failed on 5');
  CheckEquals('a0123', tiUtils.tiRemoveLeading0('a0123'), 'Failed on 6');
end;


procedure TTestTIUtils.tiMixedCase;
begin
  CheckEquals('A B C D', tiUtils.tiMixedCase('a B c D'), 'Failed on ''a B c D''');
  CheckEquals('Abc', tiUtils.tiMixedCase('abc'), 'Failed on ''abc''');
  CheckEquals('Abc', tiUtils.tiMixedCase('ABC'), 'Failed on ''ABC''');
  // Not what we would really want. Use tiStringUtils instead
  CheckEquals('A.b.c.', tiUtils.tiMixedCase('a.b.c.'), 'Failed on ''a.b..''');
  // Not what we would really want. Use tiStringUtils instead
  CheckEquals('King Charles Iii', tiUtils.tiMixedCase('king charles iii'), 'Failed on ''king charles iii''');
end;


procedure TTestTIUtils.tiReplicate;
var
  s1: string;
  i: integer;
begin
  CheckEquals('x', tiUtils.tiReplicate('x', 1), 'Failed on 1');
  CheckEquals('xx', tiUtils.tiReplicate('x', 2), 'Failed on 2');
  CheckEquals('xxxxxxxxxx', tiUtils.tiReplicate('x', 10), 'Failed on 3');
  CheckEquals('12', tiUtils.tiReplicate('12', 1), 'Failed on 4');
  CheckEquals('1212', tiUtils.tiReplicate('12', 2), 'Failed on 5');
  CheckEquals('121212', tiUtils.tiReplicate('12', 3), 'Failed on 6');
  CheckEquals('12121212', tiUtils.tiReplicate('12', 4), 'Failed on 7');
  
  s1 := '';
  for i := 1 to 256 do
    s1 := s1 + 'a';
  CheckEquals(s1, tiUtils.tiReplicate('a', 256), 'Failed on 8');
end;


procedure TTestTIUtils.tiAddTrailingValue;
begin
  Check(tiUtils.tiAddTrailingValue('', 'x', true)     = '',      'Failed on <empty string>');
  Check(tiUtils.tiAddTrailingValue('a', 'x', true)    = 'ax',    'Failed on <a>');
  Check(tiUtils.tiAddTrailingValue('axb', 'x', true)  = 'axbx',  'Failed on <axb>');
  Check(tiUtils.tiAddTrailingValue('axbx', 'x', true) = 'axbxx', 'Failed on <axbx>');
  Check(tiUtils.tiAddTrailingValue('', 'x', false)     = '',      'Failed on <empty string>');
  Check(tiUtils.tiAddTrailingValue('a', 'x', false)    = 'ax',    'Failed on <a>');
  Check(tiUtils.tiAddTrailingValue('axb', 'x', false)  = 'axbx',  'Failed on <axb>');
  Check(tiUtils.tiAddTrailingValue('axbx', 'x', false) = 'axbx',  'Failed on <axbx>');
end;


procedure TTestTIUtils.tiRemoveTrailingValue;
begin
  CheckEquals('', tiUtils.tiRemoveTrailingValue('x', 'x'), 'Failed on 1');
  CheckEquals('\abc', tiUtils.tiRemoveTrailingValue('\abcx', 'x' ), 'Failed on 2');
  CheckEquals('\abc', tiUtils.tiRemoveTrailingValue('\abc', 'x' ), 'Failed on 3');
  CheckEquals('\abc\def', tiUtils.tiRemoveTrailingValue('\abc\defx', 'x' ), 'Failed on 4');
  CheckEquals('\abc\def', tiUtils.tiRemoveTrailingValue('\abc\defx', 'x' ), 'Failed on 5');
  CheckEquals('c:\abc\def', tiUtils.tiRemoveTrailingValue('c:\abc\defx', 'x' ), 'Failed on 6');

  CheckEquals('x', tiUtils.tiRemoveTrailingValue('x', 'xx'), 'Failed on 7');
  CheckEquals('', tiUtils.tiRemoveTrailingValue('xx', 'xx'), 'Failed on 8');
  CheckEquals('\abc', tiUtils.tiRemoveTrailingValue('\abcxx', 'xx' ), 'Failed on 9');
  CheckEquals('\abc', tiUtils.tiRemoveTrailingValue('\abc', 'xx' ), 'Failed on 10');
  CheckEquals('\abc\def', tiUtils.tiRemoveTrailingValue('\abc\defxx', 'xx' ), 'Failed on 11');
  CheckEquals('\abc\def', tiUtils.tiRemoveTrailingValue('\abc\defxx', 'xx' ), 'Failed on 12');
  CheckEquals('c:\abc\def', tiUtils.tiRemoveTrailingValue('c:\abc\defxx', 'xx' ), 'Failed on 13');
end;


procedure TTestTIUtils.tiAddTrailingComma;
begin
  Check(tiUtils.tiAddTrailingComma('')     = '',      'Failed on 1');
  Check(tiUtils.tiAddTrailingComma('a')    = 'a,',    'Failed on 2');
  Check(tiUtils.tiAddTrailingComma('a,b')  = 'a,b,',  'Failed on 3');
  Check(tiUtils.tiAddTrailingComma('a,b,') = 'a,b,,', 'Failed on 4');
end;


procedure TTestTIUtils.tiAddTrailingAnd;
begin
  Check(tiUtils.tiAddTrailingAnd('')         = '',         'Failed on 1');
  Check(tiUtils.tiAddTrailingAnd('a=b')      = 'a=b and ', 'Failed on 2');
  Check(tiUtils.tiAddTrailingAnd('a=b and ') = 'a=b and ', 'Failed on 3');
end;


procedure TTestTIUtils.tiAddTrailingOr;
begin
  Check(tiUtils.tiAddTrailingOr('')        = '',        'Failed on 1');
  Check(tiUtils.tiAddTrailingOr('a=b')     = 'a=b or ', 'Failed on 2');
  Check(tiUtils.tiAddTrailingOr('a=b or ') = 'a=b or ', 'Failed on 3');
end;


procedure TTestTIUtils.tiAddTrailingSpace;
begin
  Check(tiUtils.tiAddTrailingSpace('')     = '',      'Failed on 1');
  Check(tiUtils.tiAddTrailingSpace('a')    = 'a ',    'Failed on 2');
  Check(tiUtils.tiAddTrailingSpace('a b')  = 'a b ',  'Failed on 3');
  Check(tiUtils.tiAddTrailingSpace('a b ') = 'a b  ', 'Failed on 4');
end;


// Return the first position of AValue in ATarget from the right.
procedure TTestTIUtils.tiPosR;
begin
  CheckEquals(1, tiUtils.tiPosR('a',   'axxxxx'), 'Failed on 1');
  CheckEquals(2, tiUtils.tiPosR('a',   'xaxxxx'), 'Failed on 2');
  CheckEquals(6, tiUtils.tiPosR('a',   'xxxxxa'), 'Failed on 3');
  CheckEquals(1, tiUtils.tiPosR('abc', 'abcxxxxxx'), 'Failed on 4');
  CheckEquals(2, tiUtils.tiPosR('abc', 'xabcxxxxx'), 'Failed on 5');
  CheckEquals(4, tiUtils.tiPosR('abc', 'xxxabcxxx'), 'Failed on 6');
  CheckEquals(7, tiUtils.tiPosR('abc', 'xxxxxxabc'), 'Failed on 7');
end;


procedure TTestTIUtils.tiWildcardMatch;
begin
  Check(tiUtils.tiWildCardMatch('c:\temp.txt', '*.txt'), 'Failed on 1');
  Check(tiUtils.tiWildCardMatch('temp.txt', '*.txt'), 'Failed on 2');
  Check(tiUtils.tiWildCardMatch('C:\Program files\System32\MyAp.exe', '*.exe'), 'Failed on 3');

  Check(not tiUtils.tiWildCardMatch('c:\temp.txt', '*.TXT', true), 'Failed on 4');
  Check(not tiUtils.tiWildCardMatch('temp.txt', '*.TXT', true), 'Failed on 5');
  Check(not tiUtils.tiWildCardMatch('C:\Program files\System32\MyAp.exe', '*.EXE', true), 'Failed on 6');

  Check(    tiUtils.tiWildCardMatch('abcdefg', 'abc*'),    'Failed on 7');
  Check(    tiUtils.tiWildCardMatch('abcdefg', '*abc*'),   'Failed on 8');
  Check(not tiUtils.tiWildCardMatch('abcdefg', '?bcd'),    'Failed on 9');
  Check(    tiUtils.tiWildCardMatch('abcdefg', '?bcd*'),   'Failed on 9');
  Check(    tiUtils.tiWildCardMatch('abcdefg', 'abc??fg'), 'Failed on 10');
end;


procedure TTestTIUtils.tiSubStr;
begin
  CheckEquals('', tiUtils.tiSubStr('','',''),                     'Failed on 1');
  CheckEquals('abc', tiUtils.tiSubStr('xxxabcyyy','xxx','yyy'),   'Failed on 2');
  CheckEquals('abc', tiUtils.tiSubStr('xxx,abc;xxx',',',';'),     'Failed on 3');
  CheckEquals('abc', tiUtils.tiSubStr('<d>abc</d>','<d>','</d>'), 'Failed on 4');
end;


procedure TTestTIUtils.tiAddEllipsis;
begin
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX', 13) = 'XXXXXXXXXX', 'Failed on 13');
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX', 12) = 'XXXXXXXXXX', 'Failed on 12');
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX', 11) = 'XXXXXXXXXX', 'Failed on 11');
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX', 10) = 'XXXXXXXXXX', 'Failed on 10');
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX',  9) = 'XXXXXX...',  'Failed on 9' );
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX',  8) = 'XXXXX...',   'Failed on 8' );
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX',  7) = 'XXXX...',    'Failed on 7' );
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX',  6) = 'XXX...',     'Failed on 6' );
  Check(tiUtils.tiAddEllipsis('XXXXXXXXXX',  5) = 'XX...',      'Failed on 5' );
end;


procedure TTestTIUtils.tiTrimR;
begin
  CheckEquals('', tiUtils.tiTrimR('abc', 'abc', true ), 'Failed on 1');
  CheckEquals('', tiUtils.tiTrimR('abc', 'aBc', false), 'Failed on 2');
  CheckEquals('', tiUtils.tiTrimR('abcdef', 'abc', true), 'Failed on 3');
  CheckEquals('', tiUtils.tiTrimR('abcdef', 'aBc', false), 'Failed on 4');
  CheckEquals('abc', tiUtils.tiTrimR('abcdefGhI', 'def', true), 'Failed on 5');
  CheckEquals('abc', tiUtils.tiTrimR('abcDeFGhI', 'dEf', false), 'Failed on 6');
end;


procedure TTestTIUtils.tiTrimL;
begin
  CheckEquals('', tiUtils.tiTrimL('abc', 'abc', true ), 'Failed on 1');
  CheckEquals('', tiUtils.tiTrimL('abc', 'aBc', false), 'Failed on 2');
  CheckEquals('', tiUtils.tiTrimL('abcdef', 'def', true), 'Failed on 3');
  CheckEquals('', tiUtils.tiTrimL('abcdef', 'dEf', false), 'Failed on 4');
  CheckEquals('GhI', tiUtils.tiTrimL('abcdefGhI', 'def', true), 'Failed on 5');
  CheckEquals('GhI', tiUtils.tiTrimL('abcDeFGhI', 'dEf', false), 'Failed on 6');
end;


procedure TTestTIUtils.tiRemoveCrLf;
const
  lCr = #13;
  lLf = #10;
begin
  CheckEquals(' ', tiUtils.tiRemoveCrLf(lCr + lLf), 'Failed on 1');
  CheckEquals('abc ', tiUtils.tiRemoveCrLf('abc' + lCr + lLf), 'Failed on 2');
  CheckEquals('abc  ', tiUtils.tiRemoveCrLf('abc' + lCr + lLf + lCr + lLf), 'Failed on 3');
  CheckEquals('abc   ', tiUtils.tiRemoveCrLf('abc' + lCr + lLf + lCr + lLf + lCr + lLf), 'Failed on 4');
  CheckEquals('abc   def', tiUtils.tiRemoveCrLf('abc' + lCr + lLf + lCr + lLf + lCr + lLf + 'def'), 'Failed on 5');
  CheckEquals(' ', tiUtils.tiRemoveCrLf(lCr), 'Failed on 6');
  CheckEquals('  ', tiUtils.tiRemoveCrLf(lCr + lCr), 'Failed on 7');
  CheckEquals('abc  ', tiUtils.tiRemoveCrLf('abc' + lCr + lCr), 'Failed on 8');
end;


// Remove all the trailing white space characters (#32, #10, #13)
procedure TTestTIUtils.tiTrimTrailingWhiteSpace;
const
  lCr = #13;
  lLf = #10;
begin
  CheckEquals('', tiUtils.tiTrimTrailingWhiteSpace(''), 'Failed on 1');
  CheckEquals('abc', tiUtils.tiTrimTrailingWhiteSpace('abc'), 'Failed on 2');
  CheckEquals('abc', tiUtils.tiTrimTrailingWhiteSpace('abc '), 'Failed on 3');
  CheckEquals('abc', tiUtils.tiTrimTrailingWhiteSpace('abc ' + lCr), 'Failed on 4');
  CheckEquals('abc', tiUtils.tiTrimTrailingWhiteSpace('abc ' + lCr + lLf), 'Failed on 5');
  CheckEquals('abc', tiUtils.tiTrimTrailingWhiteSpace('abc ' + lCr + lLf + lCr + lLf), 'Failed on 6');
  CheckEquals('abc' + lCr + lLf + 'def', tiUtils.tiTrimTrailingWhiteSpace('abc' + lCr + lLf + 'def'), 'Failed on 7');
end;


procedure TTestTIUtils.tiGetTempFile;
var
  i : integer;
  lFileName : string;
  lsl : TStringList;
const
  cFileCount = 100;
begin
  lsl := TStringList.Create;
  try
    lsl.Duplicates := dupError	;
    for i := 1 to cFileCount do
    begin
      lFileName := tiUtils.tiGetTempFile('tmp');
      lsl.Add(lFileName);
      Check(not FileExists(lFileName), 'File already exists');
      tiUtils.tiStringToFile('test', lFileName);
    end;
    CheckEquals(cFileCount, lsl.Count, 'Duplicate file names detected');
    for i := 0 to cFileCount - 1 do
      tiDeleteFile(lsl.Strings[i]);
  finally
    lsl.Free;
  end;
end;


procedure TTestTIUtils.tiAddTrailingSlash;
begin
  Check(tiUtils.tiAddTrailingSlash('')     = '',     'Failed on 1');
  Check(tiUtils.tiAddTrailingSlash('a')    = tiFixPathDelim('a\'),   'Failed on 2');
  Check(tiUtils.tiAddTrailingSlash(tiFixPathDelim('a\b'))  = tiFixPathDelim('a\b\'), 'Failed on 3');
  Check(tiUtils.tiAddTrailingSlash(tiFixPathDelim('a\b\')) = tiFixPathDelim('a\b\'), 'Failed on 4');
end;


procedure TTestTIUtils.tiRemoveTrailingSlash;
begin
  CheckEquals('', tiUtils.tiRemoveTrailingSlash('\'), 'Failed on 1');
  CheckEquals(tiFixPathDelim('\abc'), tiUtils.tiRemoveTrailingSlash('\abc\'), 'Failed on 2');
  CheckEquals(tiFixPathDelim('\abc'), tiUtils.tiRemoveTrailingSlash('\abc'), 'Failed on 3');
  CheckEquals(tiFixPathDelim('\abc\def'), tiUtils.tiRemoveTrailingSlash('\abc\def\'), 'Failed on 4');
  CheckEquals(tiFixPathDelim('\abc\def'), tiUtils.tiRemoveTrailingSlash('\abc\def\'), 'Failed on 2');
  CheckEquals(tiFixPathDelim('c:\abc\def'), tiUtils.tiRemoveTrailingSlash('c:\abc\def\'), 'Failed on 2');
end;


procedure TTestTIUtils.tiRemoveLeadingSlash;
begin
  CheckEquals('', tiUtils.tiRemoveLeadingSlash('\'), 'Failed on 1');
  CheckEquals('abc', tiUtils.tiRemoveLeadingSlash('\abc'), 'Failed on 2');
  CheckEquals('abc', tiUtils.tiRemoveLeadingSlash('abc'), 'Failed on 3');
  CheckEquals(tiFixPathDelim('abc\def'), tiUtils.tiRemoveLeadingSlash('\abc\def'), 'Failed on 4');
  CheckEquals(tiFixPathDelim('abc\def\'), tiUtils.tiRemoveLeadingSlash('\abc\def\'), 'Failed on 5');
end;


procedure TTestTIUtils.tiGetTempDir   ;
begin
  CheckReadingFromNT(
    tiUtils.tiRemoveTrailingSlash(tiUtils.tiGetTempDir),
    'TempDir',
    'TEMP directory (No trailing path delimiter)'
  );
end;


procedure TTestTIUtils.tiGetWindowsSysDir ;
begin
  {$IFDEF MSWINDOWS}
  CheckReadingFromNT(
    tiUtils.tiGetWindowsSysDir,
    'WindowsSysDir',
    'Windows System Directory'
  );
  {$ENDIF}
  {$IFDEF UNIX}
  Check(True, 'Not applicable');
  {$ENDIF}
end;


procedure TTestTIUtils.tiReadFileDateSize;
  procedure _SetFileDate(AFileName : string; pDate : TDateTime);
  var
    lFileHandle : Integer;
    lFileDate  : integer;
  begin
    lFileDate  := DateTimeToFileDate(pDate);
    lFileHandle := FileOpen(AFileName, fmOpenWrite or fmShareDenyNone);
    try
      FileSetDate(lFileHandle, lFileDate);
    finally
      FileClose(lFileHandle);
    end;
  end;

var
  lTargetDate : TDateTime;
  lReadDate  : TDateTime;
  lReadSize  : integer;
  lFileName  : string;

begin
  ForceDirectories(TempDirectory);
  lFileName := TempFileName('DUnitTest.txt');
  tiCreateTextFileOfSize(lFileName, 100);
  lTargetDate := EncodeDate(1980, 1, 1);
  _SetFileDate(lFileName, lTargetDate);
  tiUtils.tiReadFileDateSize(lFileName, lReadDate, lReadSize);
  CheckEquals(lTargetDate, lReadDate, '#1');
  CheckEquals(lTargetDate, tiReadFileDate(LFileName), '#2');
  CheckEquals(100, lReadSize, '#3');
  CheckEquals(100, tiReadFileSize(LFileName), '#4');
  tiDeleteFile(lFileName);

  tiCreateTextFileOfSize(lFileName, 100);
  {$IFDEF MSWINDOWS}
  lTargetDate := EncodeDate(2099, 12, 31);
  {$ENDIF}
  {$IFDEF UNIX}
  { Currently under *Unix any date later than this will rollover to zero.
    Something like the Y2K bug, but for *Unix }
  lTargetDate := EncodeDate(2038, 01, 19);
  {$ENDIF}

  _SetFileDate(lFileName, lTargetDate);
  tiUtils.tiReadFileDateSize(lFileName, lReadDate, lReadSize);
  CheckEquals(lTargetDate, lReadDate, '#5');
  CheckEquals(lTargetDate, tiReadFileDate(LFileName), '#6');
  CheckEquals(100, lReadSize, '#7');
  CheckEquals(100, tiReadFileSize(LFileName), '#8');
  tiDeleteFile(lFileName);
end;


procedure TTestTIUtils.tiSetFileDate;
var
  lsl : TStringList;
  lDate : TDateTime;
  lFileName  : string;
begin
  ForceDirectories(TempDirectory);
  lFileName := TempFileName('DUnitTest.txt');
  lsl := TStringList.Create;
  try
    lsl.Text := BuildLongString;
    lsl.SaveToFile(lFileName);

    lDate := EncodeDate(1980, 1, 1);
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 1');

    lDate := EncodeDate(1980, 1, 1);
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 2');

    {$IFDEF MSWINDOWS}
    lDate := EncodeDate(2090, 12, 31);
    {$ENDIF}
    {$IFDEF UNIX}
    { Currently under *Unix any date later than this will rollover to zero.
      Something like the Y2K bug, but for *Unix }
    lDate := EncodeDate(2038, 01, 19);
    {$ENDIF}
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 3');

    lDate := EncodeDate(2002, 1, 1) + EncodeTime(1, 0, 0, 0);
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 4');

    lDate := EncodeDate(2002, 1, 1) + EncodeTime(12, 0, 0, 0);
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 5');

    lDate := EncodeDate(2002, 1, 1) + EncodeTime(23, 59, 59, 0);
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 6');

    lDate := EncodeDate(2002, 1, 1) + EncodeTime(06, 06, 06, 0);
    tiUtils.tiSetFileDate(lFileName, lDate);
    CheckEquals(lDate, FileDateToDateTime(FileAge(lFileName)), cdtOneSecond, 'Failed on 7');
    tiDeleteFile(lFileName);

  finally
    lsl.Free;
  end;
end;


procedure TTestTIUtils.tiExtractFileNameOnly;
begin
  Check(tiUtils.tiExtractFileNameOnly('test.txt') = 'test', 'Failed on 1');
  Check(tiUtils.tiExtractFileNameOnly('c:\temp\test.txt') = 'test', 'Failed on 2');
  Check(tiUtils.tiExtractFileNameOnly('c:\temp\test.') = 'test', 'Failed on 3');
  Check(tiUtils.tiExtractFileNameOnly('c:\temp\test') = 'test', 'Failed on 4');
  Check(tiUtils.tiExtractFileNameOnly('\temp\test.txt') = 'test', 'Failed on 5');
  Check(tiUtils.tiExtractFileNameOnly('\test.txt') = 'test', 'Failed on 6');
  Check(tiUtils.tiExtractFileNameOnly('..\test.txt') = 'test', 'Failed on 2');
end;


procedure TTestTIUtils.tiRemoveExtension;
begin
  Check(tiUtils.tiRemoveExtension('test.txt') = 'test', 'Failed on 1');
  Check(tiUtils.tiRemoveExtension('c:\temp\test.txt') = 'c:\temp\test', 'Failed on 2');
  Check(tiUtils.tiRemoveExtension('c:\temp\test.') = 'c:\temp\test', 'Failed on 3');
  Check(tiUtils.tiRemoveExtension('c:\temp\test') = 'c:\temp\test', 'Failed on 4');
  Check(tiUtils.tiRemoveExtension('\temp\test.txt') = '\temp\test', 'Failed on 5');
  Check(tiUtils.tiRemoveExtension('\test.txt') = '\test', 'Failed on 6');
  Check(tiUtils.tiRemoveExtension('..\test.txt') = '..\test', 'Failed on 2');
end;


procedure TTestTIUtils.tiSwapExt;
begin
  CheckEquals('test.txt',         tiUtils.tiSwapExt('test.txt', 'txt'), 'Failed on 1');
  CheckEquals('test.hos',         tiUtils.tiSwapExt('test.txt', 'hos'), 'Failed on 2');
  CheckEquals('c:\temp\test.txt', tiUtils.tiSwapExt('c:\temp\test.txt', 'txt'), 'Failed on 3');
  CheckEquals('c:\temp\test.hos', tiUtils.tiSwapExt('c:\temp\test.txt', 'hos'), 'Failed on 3');
  CheckEquals('c:\temp\test.txt', tiUtils.tiSwapExt('c:\temp\test', 'txt'), 'Failed on 4');
  CheckEquals('c:\temp\test.',     tiUtils.tiSwapExt('c:\temp\test.txt', ''), 'Failed on 5');
end;


procedure TTestTIUtils.tiExtractExtension;
begin
  Check(tiUtils.tiExtractExtension('test.txt') = 'txt', 'Failed on 1');
  Check(tiUtils.tiExtractExtension('c:\temp\test.txt') = 'txt', 'Failed on 2');
  Check(tiUtils.tiExtractExtension('c:\temp\test.') = '', 'Failed on 3');
  Check(tiUtils.tiExtractExtension('c:\temp\test') = '', 'Failed on 4');
end;


procedure TTestTIUtils.tiCopyFile;
var
  lslFrom : TStringList;
  lslTo  : TStringList;
  lFrom  : string;
  lTo    : string;

begin
  ForceDirectories(TempDirectory);

  lFrom := TempFileName('DUnitTest_From.txt');
  lTo  := TempFileName('DUnitTest_To.txt');

  if FileExists(lFrom) then
    tiDeleteFile(lFrom);
  if FileExists(lTo) then
    tiDeleteFile(lTo);
  lslFrom := TStringList.Create;
  try
    lslTo  := TStringList.Create;
    try
      lslFrom.Text := BuildLongString;
      lslFrom.SaveToFile(lFrom);
      tiUtils.tiCopyFile(lFrom, lTo);
      lslTo.LoadFromFile(lTo);
      Check(lslFrom.Text = lslTo.Text);
    finally
      lslTo.Free;
    end;
  finally
    lslFrom.Free;
  end;
end;


procedure TTestTIUtils.tiMoveFile;
var
  lslFrom : TStringList;
  lslTo  : TStringList;
  ls : string;
  i : integer;
  j : integer;
  lFrom  : string;
  lTo    : string;
begin
  ForceDirectories(TempDirectory);

  lFrom := TempFileName('DUnitTest_From.txt');
  lTo  := TempFileName('DUnitTest_To.txt');

  if FileExists(lFrom) then
    tiDeleteFile(lFrom);
  if FileExists(lTo) then
    tiDeleteFile(lTo);

  lslFrom := TStringList.Create;
  try
    lslTo  := TStringList.Create;
    try
      for i := 0 to 1000 do
      begin
        for j := 1 to 255 do
          ls := ls + Chr(j);
        ls := ls + #13;
      end;
      lslFrom.Text := ls;
      lslFrom.SaveToFile(lFrom);
      tiUtils.tiMoveFile(lFrom, lTo);
      lslTo.LoadFromFile(lTo);
      Check(FileExists(lTo), 'To file does not exist');
      Check(not FileExists(lFrom), 'From file exists');
      Check(lslFrom.Text = lslTo.Text);
    finally
      lslTo.Free;
    end;
  finally
    lslFrom.Free;
  end;
end;


procedure TTestTIUtils.tiNormalizeStr;
begin
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr('aaa bbb'), 'Failing on 1');
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr(' aaa bbb '), 'Failing on 2');
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr(' aaa  bbb '), 'Failing on 3');
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr(' aaa   bbb '), 'Failing on 4');
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr(' aaa    bbb '), 'Failing on 5');
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr(' aaa    bbb  '), 'Failing on 6');
  CheckEquals('aaa bbb', tiUtils.tiNormalizeStr('  aaa    bbb  '), 'Failing on 7');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('  aaa    bbb cc'), 'Failing on 8');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('  aaa    bbb  cc'), 'Failing on 9');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('  aaa    bbb       cc'), 'Failing on 10');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('aaa    bbb       cc'), 'Failing on 11');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('aaa  ' + #10 + 'bbb       cc'), 'Failing on 12');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('aaa  ' + #10 + 'bbb  ' + #13#10 + '  cc'), 'Failing on 13');
  CheckEquals('aaa bbb cc', tiUtils.tiNormalizeStr('aaa  ' + #9 + 'bbb  ' + #13#10 + '  cc'), 'Failing on 14');
  CheckEquals('Select * from Modules', tiUtils.tiNormalizeStr('Select ' + #13#10 + ' * ' + #13#10 + ' from Modules    '), 'Failing on 15');
end;


{
procedure TTestTIUtils._CreateFileOfSize(AFileName : string; pSize : LongInt);
var
  lFileStream : TFileStream;
  lBuffer  : PChar;
  lLen     : integer;
  ls : string;
  i : integer;
begin
  ls := '';
  for i := 1 to pSize do
    ls := ls + Chr(Random(255 + 1));
  if FileExists(AFileName) then
    DeleteFile(AFileName);
  lFileStream := TFileStream.Create(AFileName,
                                     fmCreate or fmShareCompat);
  try
    lBuffer := PChar(ls);
    lLen := length(ls);
    lFileStream.write(lBuffer^, lLen);
  finally
    lFileStream.Free;
  end;
end;
}


procedure TTestTIUtils.tiGetFileSize;
var
  lFileName  : string;
begin
  ForceDirectories(TempDirectory);

  lFileName := TempFileName('filesizetest.txt');

  tiCreateTextFileOfSize(lFileName, 0);
  CheckEquals(0, tiUtils.tiGetFileSize(lFileName), 'Failed on 5');

  tiCreateTextFileOfSize(lFileName, 1);
  CheckEquals(1, tiUtils.tiGetFileSize(lFileName), 'Failed on 5');

  tiCreateTextFileOfSize(lFileName, 10);
  CheckEquals(10, tiUtils.tiGetFileSize(lFileName), 'Failed on 5');

  tiCreateTextFileOfSize(lFileName, 100);
  CheckEquals(100, tiUtils.tiGetFileSize(lFileName), 'Failed on 5');

  tiCreateTextFileOfSize(lFileName, 1000);
  CheckEquals(1000, tiUtils.tiGetFileSize(lFileName), 'Failed on 5');
end;


procedure TTestTIUtils.tiRemoveDrive;
begin
  {$IFDEF FPC202}
  {$NOTE FPC 2.0.2 has a bug in ExtractFileDrive (BUG ID: 4585), so lets test for it }
  CheckEquals('', ExtractFileDrive('c:'), 'Failed on 1.1 (fpc)');
  CheckEquals('c:', tiUtils.tiRemoveDrive('c:'), 'Failed on 1.2 (fpc)');
  {$ELSE}
  CheckEquals('', tiUtils.tiRemoveDrive('c:'), 'Failed on 1');
  {$ENDIF}
  CheckEquals('\temp', tiUtils.tiRemoveDrive('c:\temp'), 'Failed on 2');
  CheckEquals('\temp\hos.txt', tiUtils.tiRemoveDrive('c:\temp\hos.txt'), 'Failed on 3');
  CheckEquals('\Program Files\My Program\run.bat', tiUtils.tiRemoveDrive('c:\Program Files\My Program\run.bat'), 'Failed on 4');
end;


procedure TTestTIUtils.tiSetFileReadOnly;
var
  lsl: TStringList;
  lCurrentState: integer;
  lFileName: string;
const
  cReadOnlyBit = 0;
begin
  ForceDirectories(TempDirectory);

  lFileName := TempFileName('DUnitTest.txt');

  lsl := TStringList.Create;
  try
    lsl.Text := BuildLongString;
    lsl.SaveToFile(lFileName);
    try
      {$IFDEF MSWINDOWS}
      lCurrentState := tiWin32FileGetAttr(lFileName);
      {$ENDIF}
      {$IFDEF UNIX}
      lCurrentState := FileGetAttr(lFileName);
      {$ENDIF}
      Check((lCurrentState and (1 shl cReadOnlyBit)) = 0, 'Failed on 1');

      tiUtils.tiSetFileReadOnly(lFileName, true);
      
      {$IFDEF MSWINDOWS}
      lCurrentState := tiWin32FileGetAttr(lFileName);
      {$ENDIF}
      {$IFDEF UNIX}
      lCurrentState := FileGetAttr(lFileName);
      {$ENDIF}
      Check((lCurrentState and (1 shl cReadOnlyBit)) <> 0, 'Failed on 2');

      tiUtils.tiSetFileReadOnly(lFileName, false);
    finally
      tiDeleteFile(lFileName);
    end;
  finally
    lsl.Free;
  end;
end;


procedure TTestTIUtils.tiIsFileReadOnly;
var
  {$IFDEF MSWINDOWS}
  lCurrentState: integer;
  {$ENDIF}
  lsl: TStringList;
  lFileName: string;
const
  cReadOnly  = $00000001;
begin
  ForceDirectories(TempDirectory);

  lFileName := TempFileName('DUnitTest.txt');

  lsl := TStringList.Create;
  try
    lsl.Text := BuildLongString;
    lsl.SaveToFile(lFileName);

    Check(Not tiUtils.tiIsFileReadOnly(lFileName), 'Failed on 1');
    {$IFDEF MSWINDOWS}
    lCurrentState := tiWin32FileGetAttr(lFileName);
    tiWin32FileSetAttr(lFileName, lCurrentState xor cReadOnly);
    {$ENDIF}
    {$IFDEF UNIX}
    tiUtils.tiSetFileReadOnly(lFilename, True);
    {$ENDIF}
    Check(tiUtils.tiIsFileReadOnly(lFileName), 'Failed on 2');

    // Clean up
    {$IFDEF MSWINDOWS}
    lCurrentState := tiWin32FileGetAttr(lFileName);
    tiWin32FileSetAttr(lFileName, lCurrentState xor cReadOnly);
    {$ENDIF}
    {$IFDEF UNIX}
    tiUtils.tiSetFileReadOnly(lFileName, False);
    {$ENDIF}
  finally
    lsl.Free;
  end;
end;


procedure TTestTIUtils.tiDirectoryTreeToStringList;
var
  lsl : TStringList;
  lTempPath : string;
begin
  lTempPath := TempFileName('DUnitTests');

  lsl := TStringList.Create;
  try

    ForceDirectories(lTempPath);
    tiUtils.tiDirectoryTreeToStringList(lTempPath, lsl, true);
    CheckEquals(1, lsl.Count);
    Check(SameText(lsl.Strings[0], lTempPath),      'Failed on 00');

    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-1\Dir1-1-1'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-1\Dir1-1-2'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-1\Dir1-1-3'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-2\Dir1-2-1'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-2\Dir1-2-2'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-2\Dir1-2-3'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-3\Dir1-3-1'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-3\Dir1-3-2'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir1\Dir1-3\Dir1-3-3'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-1\Dir2-1-1'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-1\Dir2-1-2'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-1\Dir2-1-3'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-2\Dir2-2-1'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-2\Dir2-2-2'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-2\Dir2-2-3'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-3\Dir2-3-1'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-3\Dir2-3-2'));
    ForceDirectories(tiFixPathDelim(lTempPath + '\Dir2\Dir2-3\Dir2-3-3'));

    tiUtils.tiDirectoryTreeToStringList(lTempPath, lsl, false);
    CheckEquals(3, lsl.Count, 'Failed on 000');
    Check(SameText(lsl.Strings[0], lTempPath),      'Failed on 0');
    Check(SameText(lsl.Strings[1], tiFixPathDelim(lTempPath + '\Dir1')), 'Failed on 1');
    Check(SameText(lsl.Strings[2], tiFixPathDelim(lTempPath + '\Dir2')), 'Failed on 2');

    tiUtils.tiDirectoryTreeToStringList(tiFixPathDelim(lTempPath + '\'), lsl, false);
    Check(SameText(lsl.Strings[0], lTempPath),      'Failed on 0a');
    Check(SameText(lsl.Strings[1], tiFixPathDelim(lTempPath + '\Dir1')), 'Failed on 1a');
    Check(SameText(lsl.Strings[2], tiFixPathDelim(lTempPath + '\Dir2')), 'Failed on 2a');

    tiUtils.tiDirectoryTreeToStringList(lTempPath, lsl, true);
    Check(SameText(lsl.Strings[0],  lTempPath), 'Failed on 3');
    Check(SameText(lsl.Strings[1],  tiFixPathDelim(lTempPath + '\Dir1')), 'Failed on 4');
    Check(SameText(lsl.Strings[2],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-1')), 'Failed on 5');
    Check(SameText(lsl.Strings[3],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-1\Dir1-1-1')), 'Failed on 6');
    Check(SameText(lsl.Strings[4],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-1\Dir1-1-2')), 'Failed on 7');
    Check(SameText(lsl.Strings[5],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-1\Dir1-1-3')), 'Failed on 8');
    Check(SameText(lsl.Strings[6],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-2')), 'Failed on 9');
    Check(SameText(lsl.Strings[7],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-2\Dir1-2-1')), 'Failed on 10');
    Check(SameText(lsl.Strings[8],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-2\Dir1-2-2')), 'Failed on 11');
    Check(SameText(lsl.Strings[9],  tiFixPathDelim(lTempPath + '\Dir1\Dir1-2\Dir1-2-3')), 'Failed on 12');
    Check(SameText(lsl.Strings[10], tiFixPathDelim(lTempPath + '\Dir1\Dir1-3')), 'Failed on 1');
    Check(SameText(lsl.Strings[11], tiFixPathDelim(lTempPath + '\Dir1\Dir1-3\Dir1-3-1')), 'Failed on 13');
    Check(SameText(lsl.Strings[12], tiFixPathDelim(lTempPath + '\Dir1\Dir1-3\Dir1-3-2')), 'Failed on 14');
    Check(SameText(lsl.Strings[13], tiFixPathDelim(lTempPath + '\Dir1\Dir1-3\Dir1-3-3')), 'Failed on 15');
    Check(SameText(lsl.Strings[14], tiFixPathDelim(lTempPath + '\Dir2')), 'Failed on 16');
    Check(SameText(lsl.Strings[15], tiFixPathDelim(lTempPath + '\Dir2\Dir2-1')), 'Failed on 17');
    Check(SameText(lsl.Strings[16], tiFixPathDelim(lTempPath + '\Dir2\Dir2-1\Dir2-1-1')), 'Failed on 18');
    Check(SameText(lsl.Strings[17], tiFixPathDelim(lTempPath + '\Dir2\Dir2-1\Dir2-1-2')), 'Failed on 19');
    Check(SameText(lsl.Strings[18], tiFixPathDelim(lTempPath + '\Dir2\Dir2-1\Dir2-1-3')), 'Failed on 20');
    Check(SameText(lsl.Strings[19], tiFixPathDelim(lTempPath + '\Dir2\Dir2-2')), 'Failed on 21');
    Check(SameText(lsl.Strings[20], tiFixPathDelim(lTempPath + '\Dir2\Dir2-2\Dir2-2-1')), 'Failed on 22');
    Check(SameText(lsl.Strings[21], tiFixPathDelim(lTempPath + '\Dir2\Dir2-2\Dir2-2-2')), 'Failed on 23');
    Check(SameText(lsl.Strings[22], tiFixPathDelim(lTempPath + '\Dir2\Dir2-2\Dir2-2-3')), 'Failed on 24');
    Check(SameText(lsl.Strings[23], tiFixPathDelim(lTempPath + '\Dir2\Dir2-3')), 'Failed on 25');
    Check(SameText(lsl.Strings[24], tiFixPathDelim(lTempPath + '\Dir2\Dir2-3\Dir2-3-1')), 'Failed on 26');
    Check(SameText(lsl.Strings[25], tiFixPathDelim(lTempPath + '\Dir2\Dir2-3\Dir2-3-2')), 'Failed on 27');
    Check(SameText(lsl.Strings[26], tiFixPathDelim(lTempPath + '\Dir2\Dir2-3\Dir2-3-3')), 'Failed on 28');

  finally
    lsl.Free;
  end;

  tiDUnitForceRemoveDir(lTempPath);
end;


procedure TTestTIUtils.TestCreateDir;
var
  lRoot : string;
begin
  lRoot := TempFileName('DUnit2');
  tiDUnitForceRemoveDir(lRoot);
  Check(not DirectoryExists(lRoot), 'Directory exists when it should not <' + lRoot + '>');
  if not ForceDirectories(lRoot) then
    Fail('Unable to create directory <' + lRoot + '>');
  Check(DirectoryExists(lRoot), 'Unable to create directory <' + lRoot + '>');
  tiDUnitForceRemoveDir(lRoot);
end;


procedure TTestTIUtils.TestCreateFile;
var
  lsl : TStringList;
  lRoot : string;
begin
  lRoot := TempFileName('DUnitTests');
  tiDUnitForceRemoveDir(lRoot);
  if not ForceDirectories(lRoot) then
    Fail('Unable to create directory <' + lRoot + '>');
  Check(DirectoryExists(lRoot), 'Unable to create directory <' + lRoot + '>');
  lsl := TStringList.Create;
  try
    lsl.Text := 'test';
    lsl.SaveToFile(lRoot + '\temp.txt');
    Check(SysUtils.FileExists(lRoot + '\temp.txt'), 'File not found');
  finally
    lsl.Free;
  end;
  tiDUnitForceRemoveDir(lRoot);
end;


// Copy all the files, from the directory pStrStartDir, matching the wildcard pStrWildCard
procedure TTestTIUtils.tiFilesToStringList;
var
  lsl : TStringList;
  i : integer;
  lRoot : string;
begin
  lRoot := TempFileName('DUnit');
  tiDUnitForceRemoveDir(lRoot);
  if not ForceDirectories(lRoot) then
    Fail('Unable to create directory <' + lRoot + '>');
  Check(DirectoryExists(lRoot), 'Unable to create directory <' + lRoot + '>');
  for i := 0 to 100000 do begin end;

  lsl := TStringList.Create;
  try
    lsl.Text := 'test';
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\file1.txt'));
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\file2.csv'));
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\file3.exe'));
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\file4.txt'));
    tiUtils.tiFilesToStringList(lRoot, AllFilesWildCard, lsl, false);

    CheckEquals(4, lsl.Count, 'Count');
    CheckEquals(UpperCase(lsl.Strings[0]), UpperCase(tiFixPathDelim(lRoot + '\file1.txt')));
    CheckEquals(UpperCase(lsl.Strings[1]), UpperCase(tiFixPathDelim(lRoot + '\file2.csv')));
    CheckEquals(UpperCase(lsl.Strings[2]), UpperCase(tiFixPathDelim(lRoot + '\file3.exe')));
    CheckEquals(UpperCase(lsl.Strings[3]), UpperCase(tiFixPathDelim(lRoot + '\file4.txt')));

    tiUtils.tiFilesToStringList(lRoot, '*.txt', lsl, false);
    CheckEquals(2, lsl.Count, 'Count');
    CheckEquals(UpperCase(lsl.Strings[0]), UpperCase(tiFixPathDelim(lRoot + '\file1.txt')));
    CheckEquals(UpperCase(lsl.Strings[1]), UpperCase(tiFixPathDelim(lRoot + '\file4.txt')));
    tiUtils.tiFilesToStringList(lRoot, '*3.*', lsl, false);
    CheckEquals(1, lsl.Count, 'Count');
    CheckEquals(UpperCase(lsl.Strings[0]), UpperCase(tiFixPathDelim(lRoot + '\file3.exe')));

    if not ForceDirectories(tiFixPathDelim(lRoot + '\Dir1\')) then
      Fail('Unable to create directory <' + tiFixPathDelim(lRoot + '\Dir1\') + '>');
    Check(DirectoryExists(tiFixPathDelim(lRoot + '\Dir1\')), 'Unable to create directory <' + tiFixPathDelim(lRoot + '\Dir1\') + '>');
    lsl.Text := 'test';

    lsl.SaveToFile(tiFixPathDelim(lRoot + '\Dir1\file1.txt'));
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\Dir1\file2.txt'));
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\Dir1\file3.txt'));
    lsl.SaveToFile(tiFixPathDelim(lRoot + '\Dir1\file4.txt'));

    tiUtils.tiFilesToStringList(lRoot, AllFilesWildCard, lsl, true);
    CheckEquals(8, lsl.Count, 'Count');
    CheckEquals(UpperCase(lsl.Strings[0]), UpperCase(tiFixPathDelim(lRoot + '\file1.txt')));
    CheckEquals(UpperCase(lsl.Strings[1]), UpperCase(tiFixPathDelim(lRoot + '\file2.csv')));
    CheckEquals(UpperCase(lsl.Strings[2]), UpperCase(tiFixPathDelim(lRoot + '\file3.exe')));
    CheckEquals(UpperCase(lsl.Strings[3]), UpperCase(tiFixPathDelim(lRoot + '\file4.txt')));
    CheckEquals(UpperCase(lsl.Strings[4]), UpperCase(tiFixPathDelim(lRoot + '\Dir1\file1.txt')));
    CheckEquals(UpperCase(lsl.Strings[5]), UpperCase(tiFixPathDelim(lRoot + '\Dir1\file2.txt')));
    CheckEquals(UpperCase(lsl.Strings[6]), UpperCase(tiFixPathDelim(lRoot + '\Dir1\file3.txt')));
    CheckEquals(UpperCase(lsl.Strings[7]), UpperCase(tiFixPathDelim(lRoot + '\Dir1\file4.txt')));

  finally
    lsl.Free;
  end;
  tiDUnitForceRemoveDir(lRoot);
end;


procedure TTestTIUtils.tiHasSubDirectory;
var
  lDirRoot : string;
begin
  lDirRoot := TempFileName('HasSubDir');
  tiDUnitForceRemoveDir(lDirRoot);
  Check(not tiUtils.tiHasSubDirectory(lDirRoot), 'Failed on call 1');
  ForceDirectories(lDirRoot);
  Check(not tiUtils.tiHasSubDirectory(lDirRoot + '\'), 'Failed on call 2');
  ForceDirectories(tiFixPathDelim(lDirRoot + '\Level1'));
  Check(tiUtils.tiHasSubDirectory(lDirRoot), 'Failed on call 3');
  ForceDirectories(tiFixPathDelim(lDirRoot + '\Level1\'));
  Check(tiUtils.tiHasSubDirectory(lDirRoot), 'Failed on call 4');
  Check(not tiUtils.tiHasSubDirectory(lDirRoot + '\Level1\HOS'), 'Failed on call 5');
  Check(not tiUtils.tiHasSubDirectory(lDirRoot + '\Level1\HOS\'), 'Failed on call 6');
  tiDUnitForceRemoveDir(lDirRoot);
end;


procedure TTestTIUtils.tiStringToFile;
var
  lFileStream : TFileStream;
  lStringStream: TStringStream;
  lsFrom : string;
  lsTo : string;
  lFileName : string;
begin
  ForceDirectories(TempDirectory);
  lFileName := TempFileName('DUnitTest.txt');

  lsFrom := BuildLongString;
  tiUtils.tiStringToFile(lsFrom, lFileName);
  lFileStream := TFileStream.Create(lFileName,
                                     fmOpenReadWrite or fmShareDenyNone);
  try
    LFileStream.Position:= 0;
    LStringStream:= TStringStream.Create('');
    try
      LStringStream.CopyFrom(LFileStream, LFileStream.Size);
      LStringStream.Position:= 0;
      LsTo:= LStringStream.DataString;
    finally
      LStringStream.Free;
    end;
  finally
    lFileStream.Free;
  end;

  CheckEquals(lsFrom, lsTo);
  tiDeleteFile(lFileName);

end;


procedure TTestTIUtils.tiFileToString;
var
  lFileStream : TFileStream;
  LStringStream: TStringStream;
  lsFrom : string;
  lsTo : string;
  lFileName : string;
begin
  ForceDirectories(TempDirectory);
  lFileName := TempFileName('DUnitTest.txt');
  lsFrom := BuildLongString;
  lFileStream := TFileStream.Create(lFileName,
                                     fmCreate or fmShareDenyNone);
  try
    LStringStream:= TStringStream.Create(lsFrom);
    LFileStream.CopyFrom(LStringStream, LStringStream.Size);
  finally
    lFileStream.Free;
  end;
  lsTo := tiUtils.tiFileToString(lFileName);
  CheckEquals(lsFrom, lsTo);
end;


  // Extract a directory name to a certain level.
  // eg tiExtractDirToLevel('c:\temp\dir', 0) gives 'c:'
  //    tiExtractDirToLevel('c:\temp\dir', 1) gives 'c:\temp'
procedure TTestTIUtils.tiExtractDirToLevel;
const
  {$IFDEF UNIX}
  cDir = '/Temp/DUnitTests/Dir1/Dir1-1/Dir1-1-3';
  {$ELSE}
  cDir = 'C:\Temp\DUnitTests\Dir1\Dir1-1\Dir1-1-3';
  {$ENDIF}
begin
  {$IFDEF UNIX}
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 0), '/'), 'Failed on 1');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 1), '/Temp'), 'Failed on 2');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 2), '/Temp/DUnitTests'), 'Failed on 3');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 3), '/Temp/DUnitTests/Dir1'), 'Failed on 4');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 4), '/Temp/DUnitTests/Dir1/Dir1-1'), 'Failed on 5');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 5), '/Temp/DUnitTests/Dir1/Dir1-1/Dir1-1-3'), 'Failed on 6');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 6), '/Temp/DUnitTests/Dir1/Dir1-1/Dir1-1-3'), 'Failed on 7');
  {$ELSE}
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 0), 'C:'), 'Failed on 1');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 1), 'C:\Temp'), 'Failed on 2');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 2), 'C:\Temp\DUnitTests'), 'Failed on 3');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 3), 'C:\Temp\DUnitTests\Dir1'), 'Failed on 4');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 4), 'C:\Temp\DUnitTests\Dir1\Dir1-1'), 'Failed on 5');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 5), 'C:\Temp\DUnitTests\Dir1\Dir1-1\Dir1-1-3'), 'Failed on 6');
  Check(SameText(tiUtils.tiExtractDirToLevel(cDir, 6), 'C:\Temp\DUnitTests\Dir1\Dir1-1\Dir1-1-3'), 'Failed on 7');
  {$ENDIF}
end;


procedure TTestTIUtils.tiSafeDiv;
begin
  CheckEquals(0, tiUtils.tiSafeDiv(100, 0), 'Failed on 1');
  CheckEquals(10, tiUtils.tiSafeDiv(100, 10), 'Failed on 2');
  CheckEquals(222.222, tiUtils.tiSafeDiv(444.444, 2), cDUnitTestFloatPrecision, 'Failed on 3');
  CheckEquals(0, tiUtils.tiSafeDiv(444.444, 0), 'Failed on 4');
end;


procedure TTestTIUtils.tiSetPrecision;
begin
  CheckEquals(1,       tiUtils.tiSetPrecision( 1.2345, 0), cDUnitTestFloatPrecision, 'Failed on  1');
  CheckEquals(12,      tiUtils.tiSetPrecision( 12.345, 0), cDUnitTestFloatPrecision, 'Failed on  2');
  CheckEquals(123,     tiUtils.tiSetPrecision( 123.45, 0), cDUnitTestFloatPrecision, 'Failed on  3');
  CheckEquals(1235,    tiUtils.tiSetPrecision( 1234.5, 0), cDUnitTestFloatPrecision, 'Failed on  4');
  CheckEquals(12345,   tiUtils.tiSetPrecision( 12345,  0), cDUnitTestFloatPrecision, 'Failed on  5');

  CheckEquals(1.2,      tiUtils.tiSetPrecision(1.2345, 1), cDUnitTestFloatPrecision, 'Failed on  6');
  CheckEquals(12.3,     tiUtils.tiSetPrecision(12.345, 1), cDUnitTestFloatPrecision, 'Failed on  7');
  CheckEquals(123.5,    tiUtils.tiSetPrecision(123.45, 1), cDUnitTestFloatPrecision, 'Failed on  8');
  CheckEquals(1234.5,   tiUtils.tiSetPrecision(1234.5, 1), cDUnitTestFloatPrecision, 'Failed on  9');
  CheckEquals(12345.0,  tiUtils.tiSetPrecision(12345,  1), cDUnitTestFloatPrecision, 'Failed on 10');

  CheckEquals(1.23,     tiUtils.tiSetPrecision(1.2345, 2), cDUnitTestFloatPrecision, 'Failed on 11');
  CheckEquals(12.35,    tiUtils.tiSetPrecision(12.345, 2), cDUnitTestFloatPrecision, 'Failed on 12');
  CheckEquals(123.45,   tiUtils.tiSetPrecision(123.45, 2), cDUnitTestFloatPrecision, 'Failed on 13');
  CheckEquals(1234.50,  tiUtils.tiSetPrecision(1234.5, 2), cDUnitTestFloatPrecision, 'Failed on 14');
  CheckEquals(12345.00, tiUtils.tiSetPrecision(12345,  2), cDUnitTestFloatPrecision, 'Failed on 15');

  CheckEquals(1.235,     tiUtils.tiSetPrecision(1.2345, 3), cDUnitTestFloatPrecision, 'Failed on 12');
  CheckEquals(12.345,    tiUtils.tiSetPrecision(12.345, 3), cDUnitTestFloatPrecision, 'Failed on 13');
  CheckEquals(123.450,   tiUtils.tiSetPrecision(123.45, 3), cDUnitTestFloatPrecision, 'Failed on 14');
  CheckEquals(1234.500,  tiUtils.tiSetPrecision(1234.5, 3), cDUnitTestFloatPrecision, 'Failed on 15');
  CheckEquals(12345.000, tiUtils.tiSetPrecision(12345,  3), cDUnitTestFloatPrecision, 'Failed on 16');

  CheckEquals(0,         tiUtils.tiSetPrecision(1.2345, -1), cDUnitTestFloatPrecision, 'Failed on 17');
  CheckEquals(10,        tiUtils.tiSetPrecision(12.345, -1), cDUnitTestFloatPrecision, 'Failed on 18');
  CheckEquals(120,       tiUtils.tiSetPrecision(123.45, -1), cDUnitTestFloatPrecision, 'Failed on 19');
  CheckEquals(1230,      tiUtils.tiSetPrecision(1234.5, -1), cDUnitTestFloatPrecision, 'Failed on 20');
  CheckEquals(12350,     tiUtils.tiSetPrecision(12345,  -1), cDUnitTestFloatPrecision, 'Failed on 21');

  CheckEquals(0,         tiUtils.tiSetPrecision(1.2345, -2), cDUnitTestFloatPrecision, 'Failed on 22');
  CheckEquals(0,         tiUtils.tiSetPrecision(12.345, -2), cDUnitTestFloatPrecision, 'Failed on 23');
  CheckEquals(100,       tiUtils.tiSetPrecision(123.45, -2), cDUnitTestFloatPrecision, 'Failed on 24');
  CheckEquals(1200,      tiUtils.tiSetPrecision(1234.5, -2), cDUnitTestFloatPrecision, 'Failed on 25');
  CheckEquals(12300,     tiUtils.tiSetPrecision(12345,  -2), cDUnitTestFloatPrecision, 'Failed on 26');

  CheckEquals(0,         tiUtils.tiSetPrecision(1.2345, -3), cDUnitTestFloatPrecision, 'Failed on 27');
  CheckEquals(0,         tiUtils.tiSetPrecision(12.345, -3), cDUnitTestFloatPrecision, 'Failed on 28');
  CheckEquals(0,         tiUtils.tiSetPrecision(123.45, -3), cDUnitTestFloatPrecision, 'Failed on 29');
  CheckEquals(1000,      tiUtils.tiSetPrecision(1234.5, -3), cDUnitTestFloatPrecision, 'Failed on 30');
  CheckEquals(12000,     tiUtils.tiSetPrecision(12345,  -3), cDUnitTestFloatPrecision, 'Failed on 31');

  CheckEquals(0,         tiUtils.tiSetPrecision(1.2345, -4), cDUnitTestFloatPrecision, 'Failed on 32');
  CheckEquals(0,         tiUtils.tiSetPrecision(12.345, -4), cDUnitTestFloatPrecision, 'Failed on 33');
  CheckEquals(0,         tiUtils.tiSetPrecision(123.45, -4), cDUnitTestFloatPrecision, 'Failed on 34');
  CheckEquals(0,         tiUtils.tiSetPrecision(1234.5, -4), cDUnitTestFloatPrecision, 'Failed on 35');
  CheckEquals(10000,     tiUtils.tiSetPrecision(12345,  -4), cDUnitTestFloatPrecision, 'Failed on 36');

  CheckEquals(0,         tiUtils.tiSetPrecision(1.2345, -5), cDUnitTestFloatPrecision, 'Failed on 37');
  CheckEquals(0,         tiUtils.tiSetPrecision(12.345, -5), cDUnitTestFloatPrecision, 'Failed on 38');
  CheckEquals(0,         tiUtils.tiSetPrecision(123.45, -5), cDUnitTestFloatPrecision, 'Failed on 39');
  CheckEquals(0,         tiUtils.tiSetPrecision(1234.5, -5), cDUnitTestFloatPrecision, 'Failed on 40');
  CheckEquals(0,         tiUtils.tiSetPrecision(12345,  -5), cDUnitTestFloatPrecision, 'Failed on 41');

end;


procedure TTestTIUtils.tiDateToPreviousWeekDayDate;
begin
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 2, 25)) =
         EncodeDate(2002, 2, 22), 'Failed on 1');
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 2, 26)) =
         EncodeDate(2002, 2, 25), 'Failed on 2');
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 2, 27)) =
         EncodeDate(2002, 2, 26), 'Failed on 3');
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 2, 28)) =
         EncodeDate(2002, 2, 27), 'Failed on 4');
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 3, 1)) =
         EncodeDate(2002, 2, 28), 'Failed on 5');
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 3, 2)) =
         EncodeDate(2002, 3, 1), 'Failed on 6');
  Check(tiUtils.tiDateToPreviousWeekDayDate(EncodeDate(2002, 3, 3)) =
         EncodeDate(2002, 3, 1), 'Failed on 7');
end;


procedure TTestTIUtils.tiYear ;
var
  lDate : TDateTime;
begin
  lDate := EncodeDate(2000, 1, 1) + EncodeTime(6, 30, 15, 10);
  CheckEquals(2000, tiUtils.tiYear(lDate));
end;


procedure TTestTIUtils.tiStrToInt;
begin
  CheckEquals(0, tiUtils.tiStrToInt('0'));
  CheckEquals(0, tiUtils.tiStrToInt('hos'));
  CheckEquals(0, tiUtils.tiStrToInt('1+1'));
  CheckEquals(1000, tiUtils.tiStrToInt('1,000'));
  CheckEquals(1000000, tiUtils.tiStrToInt('1,000,000'));
  CheckEquals(1000, tiUtils.tiStrToInt('$ 1,000'));
end;


procedure TTestTIUtils.tiStrToFloat;
begin
  CheckEquals(0, tiUtils.tiStrToFloat('0'), 'Failed on ''0''');
  CheckEquals(0, tiUtils.tiStrToFloat('hos'), 'Failed on ''hos''');
  CheckEquals(0, tiUtils.tiStrToFloat('1+1'), 'Failed on ''1+1''');
  CheckEquals(1000, tiUtils.tiStrToFloat('1,000'), 'Failed on ''1,000''');
  CheckEquals(1000000, tiUtils.tiStrToFloat('1,000,000'), 'Failed on ''1,000,000''');
  CheckEquals(1000, tiUtils.tiStrToFloat('$ 1,000'), 'Failed on ''$ 1,000''');
end;


procedure TTestTIUtils.tiDateToStr;
const
  cExpected = '01%s01%s2000';
var
  lDate : TDateTime;
  lExpected: string;
begin
  lExpected := Format(cExpected, [DateSeparator, DateSeparator]);
  lDate := EncodeDate(2000, 1, 1) + EncodeTime(6, 30, 15, 10);
  Check(tiUtils.tiDateToStr(lDate) =
         lExpected,
         'Got <' + tiUtils.tiDateTimeToStr(lDate) + '> expected <' + lExpected + '>');
end;


procedure TTestTIUtils.tiDateTimeToStr;
const
  cExpected = '01%s01%s2000 06%s30%s15';
{  cExpected = '01' + DateSeparator + '01' + DateSeparator + '2000 06' +
              TimeSeparator + '30' + TimeSeparator + '15';
}
var
  lDate: TDateTime;
  lExpected: string;
begin
  lExpected := Format(cExpected, [DateSeparator, DateSeparator, TimeSeparator, TimeSeparator]);
  lDate := EncodeDate(2000, 1, 1) + EncodeTime(6, 30, 15, 10);
  Check(tiUtils.tiDateTimeToStr(lDate) =
         lExpected,
         'Got <' + tiUtils.tiDateTimeToStr(lDate) + '> expected <' + lExpected + '>');
end;


procedure TTestTIUtils.tiTimeToStr;
var
  lDate : TDateTime;
const
  cExpected = '06:30:15';
begin
  lDate := EncodeDate(2000, 1, 1) + EncodeTime(6, 30, 15, 10);
  Check(tiUtils.tiTimeToStr(lDate) =
         cExpected,
         'Got <' + tiUtils.tiTimeToStr(lDate) + '> expected <' + cExpected + '>');
end;


procedure TTestTIUtils.tiIntToStrHide0;
begin
  CheckEquals('',  tiUtils.tiIntToStrHide0(0), 'Failed on 0');
  CheckEquals('10', tiUtils.tiIntToStrHide0(10), 'Failed on 10');
  CheckEquals('-10', tiUtils.tiIntToStrHide0(-10), 'Failed on -10');
end;


procedure TTestTIUtils.tiIntToCommaStr;
begin
  CheckEquals('0', tiUtils.tiIntToCommaStr(0), 'Failed on 0');
  CheckEquals('10', tiUtils.tiIntToCommaStr(10), 'Failed on 10');
  CheckEquals('100', tiUtils.tiIntToCommaStr(100), 'Failed on 100');
  CheckEquals('1,000', tiUtils.tiIntToCommaStr(1000), 'Failed on 1000');
  CheckEquals('10,000', tiUtils.tiIntToCommaStr(10000), 'Failed on 10000');
  CheckEquals('100,000', tiUtils.tiIntToCommaStr(100000), 'Failed on 100000');
  CheckEquals('1,000,000', tiUtils.tiIntToCommaStr(1000000), 'Failed on 1000000');
  CheckEquals('-10', tiUtils.tiIntToCommaStr(-10), 'Failed on -10');
  CheckEquals('-100', tiUtils.tiIntToCommaStr(-100), 'Failed on -100');
  CheckEquals('-1,000', tiUtils.tiIntToCommaStr(-1000), 'Failed on -1000');
  CheckEquals('-10,000', tiUtils.tiIntToCommaStr(-10000), 'Failed on -10000');
  CheckEquals('-100,000', tiUtils.tiIntToCommaStr(-100000), 'Failed on -100000');
  CheckEquals('-1,000,000', tiUtils.tiIntToCommaStr(-1000000), 'Failed on -1000000');
end;


procedure TTestTIUtils.tiFloatToCurrencyHide0;
begin
  CheckEquals('', tiUtils.tiFloatToCurrencyHide0(0), 'Failed on 1');
  CheckEquals('$ 0.01', tiUtils.tiFloatToCurrencyHide0(0.01), 'Failed on 2');
  CheckEquals('', tiUtils.tiFloatToCurrencyHide0(0.001), 'Failed on 3');
  CheckEquals('$ 0.01', tiUtils.tiFloatToCurrencyHide0(0.005), 'Failed on 4');
  CheckEquals('$ 100.00', tiUtils.tiFloatToCurrencyHide0(100), 'Failed on 5');
  CheckEquals('$ 1,000.00', tiUtils.tiFloatToCurrencyHide0(1000), 'Failed on 6');
  CheckEquals('$ 1,000,000.00', tiUtils.tiFloatToCurrencyHide0(1000000), 'Failed on 7');
end;


procedure TTestTIUtils.tiFloatToCurrency;
begin
  CheckEquals('$ 0.00', tiUtils.tiFloatToCurrency(0), 'Failed on 1');
  CheckEquals('$ 0.01', tiUtils.tiFloatToCurrency(0.01), 'Failed on 2');
  CheckEquals('$ 0.00', tiUtils.tiFloatToCurrency(0.001), 'Failed on 3');
  CheckEquals('$ 0.01', tiUtils.tiFloatToCurrency(0.005), 'Failed on 4');
  CheckEquals('$ 100.00', tiUtils.tiFloatToCurrency(100), 'Failed on 5');
  CheckEquals('$ 1,000.00', tiUtils.tiFloatToCurrency(1000), 'Failed on 6');
  CheckEquals('$ 1,000,000.00', tiUtils.tiFloatToCurrency(1000000), 'Failed on 7');
end;

procedure TTestTIUtils.tiBooleanToStr;
begin
  Check(SameText(tiUtils.tiBooleanToStr(true), cTrueDB), 'Failed on <true>');
  Check(SameText(tiUtils.tiBooleanToStr(false), cFalseDB), 'Failed on <false>');
end;


procedure TTestTIUtils.tiStrToBool;
begin                                    
  CheckEquals(false, tiUtils.tiStrToBool('false'), 'Failed on false');
  CheckEquals(false, tiUtils.tiStrToBool('False'), 'Failed on False');
  CheckEquals(true,  tiUtils.tiStrToBool('true'),  'Failed on true');
  CheckEquals(true,  tiUtils.tiStrToBool('True'),  'Failed on True');
  CheckEquals(true,  tiUtils.tiStrToBool('t'),     'Failed on t');
  CheckEquals(true,  tiUtils.tiStrToBool('T'),     'Failed on T');
  CheckEquals(false, tiUtils.tiStrToBool('f'),     'Failed on f');
  CheckEquals(false, tiUtils.tiStrToBool('F'),     'Failed on F');
  CheckEquals(true,  tiUtils.tiStrToBool('1'),     'Failed on 1');
  CheckEquals(false, tiUtils.tiStrToBool('0'),     'Failed on 0');
  CheckEquals(false, tiUtils.tiStrToBool('AnyOtherStrings'), 'Failed on AnyOtherString');
end;


procedure TTestTIUtils.tiFloatToStr;
begin
  Check(tiUtils.tiFloatToStr(1,      0) = '1');
  Check(tiUtils.tiFloatToStr(12,     0) = '12');
  Check(tiUtils.tiFloatToStr(123,    0) = '123');
  Check(tiUtils.tiFloatToStr(1234,   0) = '1234');
  Check(tiUtils.tiFloatToStr(1.1,    0) = '1');
  Check(tiUtils.tiFloatToStr(12.1,   0) = '12');
  Check(tiUtils.tiFloatToStr(123.1,  0) = '123');
  Check(tiUtils.tiFloatToStr(1234.1, 0) = '1234');
  Check(tiUtils.tiFloatToStr(1,      1) = '1.0');
  Check(tiUtils.tiFloatToStr(12,     1) = '12.0');
  Check(tiUtils.tiFloatToStr(123,    1) = '123.0');
  Check(tiUtils.tiFloatToStr(1234,   1) = '1234.0');
  Check(tiUtils.tiFloatToStr(1.1,    1) = '1.1');
  Check(tiUtils.tiFloatToStr(12.1,   1) = '12.1');
  Check(tiUtils.tiFloatToStr(123.1,  1) = '123.1');
  Check(tiUtils.tiFloatToStr(1234.1, 1) = '1234.1');
  Check(tiUtils.tiFloatToStr(1,      2) = '1.00');
  Check(tiUtils.tiFloatToStr(12,     2) = '12.00');
  Check(tiUtils.tiFloatToStr(123,    2) = '123.00');
  Check(tiUtils.tiFloatToStr(1234,   2) = '1234.00');
  Check(tiUtils.tiFloatToStr(1.1,    2) = '1.10');
  Check(tiUtils.tiFloatToStr(12.1,   2) = '12.10');
  Check(tiUtils.tiFloatToStr(123.1,  2) = '123.10');
  Check(tiUtils.tiFloatToStr(1234.1, 2) = '1234.10');
  Check(tiUtils.tiFloatToStr(1.14,   1) = '1.1');
  Check(tiUtils.tiFloatToStr(12.15,  1) = '12.2');
end;


procedure TTestTIUtils.tiFloatToCommaStr;
begin
  Check(tiUtils.tiFloatToCommaStr(1,      0) = '1');
  Check(tiUtils.tiFloatToCommaStr(12,     0) = '12');
  Check(tiUtils.tiFloatToCommaStr(123,    0) = '123');
  Check(tiUtils.tiFloatToCommaStr(1234,   0) = '1,234');
  Check(tiUtils.tiFloatToCommaStr(1.1,    0) = '1');
  Check(tiUtils.tiFloatToCommaStr(12.1,   0) = '12');
  Check(tiUtils.tiFloatToCommaStr(123.1,  0) = '123');
  Check(tiUtils.tiFloatToCommaStr(1234.1, 0) = '1,234');
  Check(tiUtils.tiFloatToCommaStr(1,      1) = '1.0');
  Check(tiUtils.tiFloatToCommaStr(12,     1) = '12.0');
  Check(tiUtils.tiFloatToCommaStr(123,    1) = '123.0');
  Check(tiUtils.tiFloatToCommaStr(1234,   1) = '1,234.0');
  Check(tiUtils.tiFloatToCommaStr(1.1,    1) = '1.1');
  Check(tiUtils.tiFloatToCommaStr(12.1,   1) = '12.1');
  Check(tiUtils.tiFloatToCommaStr(123.1,  1) = '123.1');
  Check(tiUtils.tiFloatToCommaStr(1234.1, 1) = '1,234.1');
  Check(tiUtils.tiFloatToCommaStr(1,      2) = '1.00');
  Check(tiUtils.tiFloatToCommaStr(12,     2) = '12.00');
  Check(tiUtils.tiFloatToCommaStr(123,    2) = '123.00');
  Check(tiUtils.tiFloatToCommaStr(1234,   2) = '1,234.00');
  Check(tiUtils.tiFloatToCommaStr(1.1,    2) = '1.10');
  Check(tiUtils.tiFloatToCommaStr(12.1,   2) = '12.10');
  Check(tiUtils.tiFloatToCommaStr(123.1,  2) = '123.10');
  Check(tiUtils.tiFloatToCommaStr(1234.1, 2) = '1,234.10');
  Check(tiUtils.tiFloatToCommaStr(1.14,   1) = '1.1');
  Check(tiUtils.tiFloatToCommaStr(12.15,  1) = '12.2');
end;


procedure TTestTIUtils._tiFloatToStr;
begin
  Check(tiUtils._tiFloatToStr(1,      0, '###0') = '1');
  Check(tiUtils._tiFloatToStr(12,     0, '###0') = '12');
  Check(tiUtils._tiFloatToStr(123,    0, '###0') = '123');
  Check(tiUtils._tiFloatToStr(1234,   0, '###0') = '1234');
  Check(tiUtils._tiFloatToStr(1.1,    0, '###0') = '1');
  Check(tiUtils._tiFloatToStr(12.1,   0, '###0') = '12');
  Check(tiUtils._tiFloatToStr(123.1,  0, '###0') = '123');
  Check(tiUtils._tiFloatToStr(1234.1, 0, '###0') = '1234');
  Check(tiUtils._tiFloatToStr(1,      1, '###0') = '1.0');
  Check(tiUtils._tiFloatToStr(12,     1, '###0') = '12.0');
  Check(tiUtils._tiFloatToStr(123,    1, '###0') = '123.0');
  Check(tiUtils._tiFloatToStr(1234,   1, '###0') = '1234.0');
  Check(tiUtils._tiFloatToStr(1.1,    1, '###0') = '1.1');
  Check(tiUtils._tiFloatToStr(12.1,   1, '###0') = '12.1');
  Check(tiUtils._tiFloatToStr(123.1,  1, '###0') = '123.1');
  Check(tiUtils._tiFloatToStr(1234.1, 1, '###0') = '1234.1');
  Check(tiUtils._tiFloatToStr(1,      2, '###0') = '1.00');
  Check(tiUtils._tiFloatToStr(12,     2, '###0') = '12.00');
  Check(tiUtils._tiFloatToStr(123,    2, '###0') = '123.00');
  Check(tiUtils._tiFloatToStr(1234,   2, '###0') = '1234.00');
  Check(tiUtils._tiFloatToStr(1.1,    2, '###0') = '1.10');
  Check(tiUtils._tiFloatToStr(12.1,   2, '###0') = '12.10');
  Check(tiUtils._tiFloatToStr(123.1,  2, '###0') = '123.10');
  Check(tiUtils._tiFloatToStr(1234.1, 2, '###0') = '1234.10');
  Check(tiUtils._tiFloatToStr(1.14,   1, '###0') = '1.1');
  Check(tiUtils._tiFloatToStr(12.15,  1, '###0') = '12.2');
end;


  // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // *
  // *  Win32 API wrappers
  // *
  // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

procedure TTestTIUtils.tiGetUserName ;
begin
  CheckReadingFromNT(
    tiUtils.tiGetUserName,
    'UserName',
    'User''s name'
  );
end;


procedure TTestTIUtils.tiGetComputerName ;
begin
  CheckReadingFromNT(
    tiUtils.tiGetComputerName,
    'ComputerName',
    'name'
  );
end;


// This test is really inadequate, but then tiVariantArrayToString should be
// re-worked to remove the TStringList as the working holder of the data.
procedure TTestTIUtils.tiVariantArrayToString;
var
  lFrom : OleVariant;
  lTo  : string;
const
  lCrLf = #13 + #10;
begin
  lFrom := VarArrayOf(['xxx']);
  lTo :=
    '[' + lCrLf +
    ' ' + 'xxx' +
    lCrLf + ']' +
    lCrLf;

  CheckEquals(lTo, tiUtils.tiVariantArrayToString(lFrom), 'Failed on 1 ('+IntToStr(VarType(lFrom))+')');

  lFrom := VarArrayOf(['xxx', 'yyy']);
  lTo :=
    '[' + lCrLf +
    ' ' + 'xxx' + lCrLf +
    ' ' + 'yyy' + lCrLf +
    ']' + lCrLf;
  CheckEquals(lTo, tiUtils.tiVariantArrayToString(lFrom), 'Failed on 2');

  lFrom := VarArrayOf(['xxx', 'yyy', 'zzz' ]);
  lTo :=
    '[' + lCrLf +
    ' ' + 'xxx' + lCrLf +
    ' ' + 'yyy' + lCrLf +
    ' ' + 'zzz' + lCrLf +
    ']' + lCrLf;
  CheckEquals(lTo, tiUtils.tiVariantArrayToString(lFrom), 'Failed on 3');

  lFrom := VarArrayOf(['xxx', VarArrayOf(['yyy'])]);
  lTo :=
    '[' + lCrLf +
    ' ' + 'xxx' + lCrLf +
    '   [' + lCrLf +
    '    ' + 'yyy' + lCrLf +
    '   ]' + lCrLf +
    ']' + lCrLf;

  CheckEquals(lTo, tiUtils.tiVariantArrayToString(lFrom), 'Failed on 3');

  lFrom := VarArrayOf(['xxx', VarArrayOf(['yyy', 'zzz'])]);
  lTo :=
    '[' + lCrLf +
    ' ' + 'xxx' + lCrLf +
    '   [' + lCrLf +
    '    ' + 'yyy' + lCrLf +
    '    ' + 'zzz' + lCrLf +
    '   ]' + lCrLf +
    ']' + lCrLf;

  CheckEquals(lTo, tiUtils.tiVariantArrayToString(lFrom), 'Failed on 3');

//  tiShowString('|' +
//    tiUtils.tiVariantArrayToString(lFrom) +
//    '|' + CrLf + CrLf +
//    '|' + lTo + '|');

end;


procedure TTestTIUtils.tiIsVariantOfType;

  procedure _tiIsVariantOfType(xVar : variant; xExpected : TVarType; xMsg : string);

    procedure __tiIsVariantOfType(xxCheck : TVarType; xxMsg : string);
    begin
      if xxCheck=xExpected then
        Check(tiUtils.tiIsVariantOfType(xVar, xxCheck), xMsg)
      else
        Check(not tiUtils.tiIsVariantOfType(xVar, xxCheck), xMsg + ' - '+xxMsg);
    end;

  begin
    __tiIsVariantOfType(varEmpty,'varEmpty');
    __tiIsVariantOfType(varNull,'varNull');
    __tiIsVariantOfType(varSmallint,'varSmallInt');
    __tiIsVariantOfType(varInteger,'varInteger');
    __tiIsVariantOfType(varSingle,'varSingle');
    __tiIsVariantOfType(varDouble,'varDouble');
    __tiIsVariantOfType(varDate,'varDate');
    __tiIsVariantOfType(varBoolean,'varBoolean');
    __tiIsVariantOfType(varOleStr,'varOleStr');
  end;
var
  lVar : Variant;
//  lShortString : Char;
  lSmallInt : Smallint;
  lInteger : Integer;
  lDouble : Double;      
  lDateTimeNow : TDateTime;
  lDateTimeDate : TDateTime;
  lOleString : WideString;
//  lString : string;
  lBoolean : boolean;
  lCurrency : Currency;
begin
  lSmallInt := 123;
  lInteger := High(Integer);
  lDouble := 123.45678901234567890;
  lDateTimeNow := Now;
  lDateTimeDate := Date;
  lOleString := 'OLE STRING TEST';
//  lString := 'STRING TEST';
  lBoolean := true;
  lCurrency := 12345678.9876;

  lVar := Unassigned;
//  lVar := VarAsType('',varEmpty);
  _tiIsVariantOfType(lVar,varEmpty,'Failed with varEmpty');

  lVar := Null;
  _tiIsVariantOfType(lVar,varNull,'Failed with varNull');

  // There is no other way to receive variant of type small int...
  lVar:=VarAsType(lSmallInt,varSmallint);
  _tiIsVariantOfType(lVar,varSmallInt,'Failed with VarSmallint');

  lVar:=lInteger;
  _tiIsVariantOfType(lVar,varInteger,'Failed with Integer');

  lVar:=VarAsType(123.456,varSingle);
  _tiIsVariantOfType(lVar,varSingle,'Failed with VarSingle');

  lVar:=lDouble;
  _tiIsVariantOfType(lVar,varDouble,'Failed with VarDouble');

  lVar:=lDateTimeDate;
  _tiIsVariantOfType(lVar,varDate,'Failed with varDate - DATE');

  lVar:=lDateTimeNow;
  _tiIsVariantOfType(lVar,varDate,'Failed with varDate - NOW');
  Check(tiUtils.tiIsVariantOfType(lVar, varDate), 'Failed with varDate');

  lVar:=lBoolean;
  _tiIsVariantOfType(lVar,varBoolean,'Failed with varBoolean');

  lVar:=lOleString;
  _tiIsVariantOfType(lVar,varOLEStr,'Failed with varOLEStr');

// Can't make this one work
//  lVar := 'test';
//  Check(tiUtils.tiIsVariantOfType(lVar, varString), 'Failed with varString');

  lVar:=lCurrency;
  _tiIsVariantOfType(lVar,varCurrency,'Failed with varCurrency');

// These ones have not been tested
// varCurrency	Currency floating-point value (type Currency).
// varDispatch	Reference to an Automation object (an IDispatch interface pointer).
// varError	Operating system error code.
// varUnknown	Reference to an unknown COM object (an IUnknown interface pointer).
// varByte	8-bit unsigned integer (type Byte).
// varTypeMask	Bit mask for extracting type code.
// varArray	Bit indicating variant array.
// varByRef	Bit indicating variant contains a reference (rather than a value).
end;


procedure TTestTIUtils.Lf;
begin
  Check(tiUtils.Lf = #10);
  Check(tiUtils.Lf(1) = #10);
  Check(tiUtils.Lf(2) = #10 + #10);
  Check(tiUtils.Lf(3) = #10 + #10 + #10);
  Check(tiUtils.Lf(4) = #10 + #10 + #10 + #10);
  Check(tiUtils.Lf(5) = #10 + #10 + #10 + #10 + #10);
end;


procedure TTestTIUtils.Cr;
begin
  Check(tiUtils.Cr = #13);
  Check(tiUtils.Cr(1) = #13);
  Check(tiUtils.Cr(2) = #13 + #13);
  Check(tiUtils.Cr(3) = #13 + #13 + #13);
  Check(tiUtils.Cr(4) = #13 + #13 + #13 + #13);
  Check(tiUtils.Cr(5) = #13 + #13 + #13 + #13 + #13);
end;


procedure TTestTIUtils.CrLf;
begin
  Check(tiUtils.CrLF = #13 + #10);
  Check(tiUtils.CrLF(1) = #13 + #10);
  Check(tiUtils.CrLF(2) = #13 + #10 + #13 + #10);
  Check(tiUtils.CrLF(3) = #13 + #10 + #13 + #10 + #13 + #10);
  Check(tiUtils.CrLF(4) = #13 + #10 + #13 + #10 + #13 + #10 + #13 + #10);
  Check(tiUtils.CrLF(5) = #13 + #10 + #13 + #10 + #13 + #10 + #13 + #10 + #13 + #10);
end;


procedure TTestTIUtils.tiListToStreamDefault;
var
  lStream : TStringStream;
  lList  : TTestListOfPersistents;
begin
  lStream := TStringStream.Create('');
  try
    lList := TTestListOfPersistents.Create;
    try
      tiUtils.tiListToStream(lStream, lList);
      CheckEquals(Length(lList.AsString), lStream.Size, 'Failing on 1');
      CheckEquals(lList.AsString, lStream.DataString, 'Failing on 2');
    finally
      lList.Free;
    end;
  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiListToStreamDelims;
var
  lStream : TStringStream;
  lList  : TTestListOfPersistents;
  lFields : TStringList;
begin
  lStream := TStringStream.Create('');
  try
    lList  := TTestListOfPersistents.Create;
    try
      lFields := TStringList.Create;
      try
        lFields.Add('Caption');
        lFields.Add('StringProp');
        lFields.Add('IntProp');
        lFields.Add('DateTimeProp');
        lFields.Add('FloatProp');
        tiUtils.tiListToStream(lStream, lList, #9, '|', lFields);
        CheckEquals(Length(lList.AsString(#9, '|', lFields)), lStream.Size);
        CheckEquals(lList.AsString(#9, '|', lFields), lStream.DataString);
      finally
        lFields.Free;
      end;
    finally
      lList.Free;
    end;
  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiListToStreamFields;
var
  lStream : TStringStream;
  lList  : TTestListOfPersistents;
  lFields : TStringList;
begin
  lStream := TStringStream.Create('');
  try
    lList  := TTestListOfPersistents.Create;
    try
      lFields := TStringList.Create;
      try
        lFields.Add('StringProp');
        lFields.Add('IntProp');
        lFields.Add('FloatProp');
        tiUtils.tiListToStream(lStream, lList, ',', #13#10, lFields);
        CheckEquals(Length(lList.AsString(',', #13#10, lFields)), lStream.Size);
        CheckEquals(lList.AsString(',', #13#10, lFields), lStream.DataString);
      finally
        lFields.Free;
      end;
    finally
      lList.Free;
    end;
  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiListToCSVDefault;
var
  lList: TTestListOfPersistents;
  lString1: string;
  lString2: string;
  lFileName: string;
  lFields: TStringList;
begin
  ForceDirectories(TempDirectory);
  lFileName := TempFileName('DUnitTest.txt');
  lList := TTestListOfPersistents.Create;
  try
    tiUtils.tiListToCSV(lList, lFileName);
    lString1 := tiUtils.tiFileToString(lFileName);
    tiDeleteFile(lFileName);
    lFields := TStringList.Create;
    try
      lFields.Add('Caption');
      lFields.Add('StringProp');
      lFields.Add('IntProp');
      lFields.Add('DateTimeProp');
      lFields.Add('FloatProp');
      lString2 := lList.AsString(',', #13#10, lFields);
    finally
      lFields.Free;
    end;
  finally
    lList.Free;
  end;

  CheckEquals(Length(lString1), Length(lString2), 'Failed on 1');
  CheckEquals(lString1, lString2, 'Failed on 2');
end;


procedure TTestTIUtils.tiListToCSVFields;
var
  lList      : TTestListOfPersistents;
  lString1: string;
  lString2 : string;
  lFileName : string;
  lFields: TStringList;
begin
  ForceDirectories(TempDirectory);
  lFileName := TempFileName('DUnitTest.txt');
  lList  := TTestListOfPersistents.Create;
  try
    lFields:= TStringList.Create;
    try
      lFields.Add('StringProp');
      lFields.Add('IntProp');
      lFields.Add('FloatProp');
      tiUtils.tiListToCSV(lList, lFileName, lFields);
      lString1 := tiUtils.tiFileToString(lFileName);
      tiDeleteFile(lFileName);
      lString2 := lList.AsString(',', #13#10, lFields);
    finally
      lFields.Free;
    end;
  finally
    lList.Free;
  end;

  CheckEquals(Length(lString1), Length(lString2), 'Length');
  CheckEquals(lString1, lString2, 'String');
end;


procedure TTestTIUtils.tiListToClipboardDefault;
var
  lList: TTestListOfPersistents;
  lString1: string;
  lString2: string;
  lFields: TStringList;
begin
  lList := TTestListOfPersistents.Create;
  try
    lFields := TStringList.Create;
    try
//      {$IFNDEF FPC}
      lFields.Add('Caption');
//      {$ENDIF}
      lFields.Add('StringProp');
      lFields.Add('IntProp');
      lFields.Add('DateTimeProp');
      lFields.Add('FloatProp');
//      {$IFDEF FPC}
//      lFields.Add('Caption');
//      {$ENDIF}
      tiUtils.tiListToClipboard(lList);
      lString1 := ClipBoard.AsText;
      lString2 := lList.AsString(#9, #13#10, lFields);
    finally
      lFields.Free;
    end;
  finally
    lList.Free;
  end;

  CheckEquals(Length(lString1), Length(lString2), 'Failed on 1');
  CheckEquals(lString1, lString2, 'Failed on 2');
end;


procedure TTestTIUtils.tiListToClipboardFields;
var
  lList      : TTestListOfPersistents;
  lString1: string;
  lString2 : string;
  lFields: TStringList;
begin
  lList  := TTestListOfPersistents.Create;
  try
    lFields:= TStringList.Create;
    try
      lFields.Add('StringProp');
      lFields.Add('IntProp');
      lFields.Add('FloatProp');
      tiUtils.tiListToClipboard(lList, lFields);
      lString1 := ClipBoard.AsText;
      lString2 := lList.AsString(#9, #13#10, lFields);
    finally
      lFields.Free;
    end;
  finally
    lList.Free;
  end;

  CheckEquals(Length(lString1), Length(lString2), 'Length');
  CheckEquals(lString1, lString2, 'String');
end;


function TTestTIUtils.BuildLongString: string;
var
  i, j : integer;
begin
  result := '' ;
  for i := 0 to 1000 do
  begin
    for j := 32 to 255 do
      result := result + Chr(j);
    result := result + #13;
  end;
end;


type
{$M+}
  TCheckRTTI_1 = class(TObject);
{$M-}

  TCheckRTTI_2 = class(TObject);


procedure TTestTIUtils.tiHasRTTIOnClass;
begin
  Check(not tiHasRTTI(TObject), 'tiHasRTTI(TObject) <> false');
  Check(tiHasRTTI(TPersistent), 'tiHasRTTI(TPersistent) <> true');
  Check(tiHasRTTI(TCheckRTTI_1), 'tiHasRTTI(TCheckRTTI_1) <> true');
  Check(not tiHasRTTI(TCheckRTTI_2), 'iHasRTTI(TCheckRTTI_2) <> false');
end;


procedure TTestTIUtils.tiHasRTTIOnObject;
var
  lObj : TObject;
begin
  lObj := TObject.Create;
  Check(not tiHasRTTI(lObj), 'tiHasRTTI(TObject) <> false');
  lObj.Free;

  lObj := TPersistent.Create;
  Check(tiHasRTTI(lObj), 'tiHasRTTI(TObject) <> true');
  lObj.Free;

  lObj := TCheckRTTI_1.Create;
  Check(tiHasRTTI(lObj), 'tiHasRTTI(TCheckRTTI_1) <> true');
  lObj.Free;

  lObj := TCheckRTTI_2.Create;
  Check(not tiHasRTTI(lObj), 'iHasRTTI(TCheckRTTI_2) <> false');
  lObj.Free;
end;


procedure TTestTIUtils.CheckReadingFromNT(const AValue, pRegKey, pDescription : string);
var
  lEntered : string;
begin
  {$IFDEF FPC}
  lEntered := gDUnitINI.ReadString(cINIMachineSettings, pRegKey, '');
  {$ELSE}
  lEntered := gDUnitReg.ReadString(cINIMachineSettings, pRegKey, '');
  {$ENDIF}

  if lEntered = '' then
  begin
    tiInputQuery(lEntered,
                  'What is this computer''s ' + pDescription + '?');
    lEntered := lEntered;
    {$IFDEF FPC}
    gDUnitINI.WriteString(cINIMachineSettings, pRegKey, lEntered);
    {$ELSE}
    gDUnitReg.WriteString(cINIMachineSettings, pRegKey, lEntered);
    {$ENDIF}
  end;
  CheckEquals(UpperCase(lEntered),
               UpperCase(AValue), 'Confirm this computer''s ' + pDescription + ' ' + lEntered);
end;


procedure TTestTIUtils.tiForceRemoveDir;
var
  lRoot : string;
begin
  lRoot := TempFileName(tiFixPathDelim('DUnitTests\ForceRemoveDir'));
  ForceDirectories(lRoot);
  tiCreateTextFileOfSize(tiFixPathDelim(lRoot + '\file1.txt'), 100);
  ForceDirectories(tiFixPathDelim(lRoot + '\dir1'));
  tiCreateTextFileOfSize(tiFixPathDelim(lRoot + '\dir1\file2.txt'), 100);
  tiUtils.tiSetFileReadOnly(tiFixPathDelim(lRoot + '\dir1\file2.txt'), true);
  ForceDirectories(tiFixPathDelim(lRoot + '\dir2'));
  tiUtils.tiForceRemoveDir(lRoot);
  Check(Not DirectoryExists(lRoot));
  tiDUnitForceRemoveDir(lRoot);
end;


procedure TTestTIUtils.tiIsEMailAddressValid;
begin
  Check(not tiUtils.tiIsEMailAddressValid(''), 'Failed on <>');
  Check(not tiUtils.tiIsEMailAddressValid('pwh'), 'Failed on <pwh>');
  Check(not tiUtils.tiIsEMailAddressValid('pwh@'), 'Failed on <pwh@>');
  Check(not tiUtils.tiIsEMailAddressValid('pwh@techinsite'), 'Failed on <pwh@techinsite>');
  Check(    tiUtils.tiIsEMailAddressValid('pwh@techinsite.com'), 'Failed on <pwh@techinsite.com>');
  Check(    tiUtils.tiIsEMailAddressValid('pwh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p(wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p)wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p<wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p>wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p@wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p,wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p;wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p:wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p/wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p/wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p"wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(    tiUtils.tiIsEMailAddressValid('p.wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p[wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid('p]wh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  Check(not tiUtils.tiIsEMailAddressValid(#127+'pwh@techinsite.com.au'), 'Failed on <pwh@techinsite.com.au>');
  //ToDo: These tests could be more complete. For example, the
  //      name part of an email address has not been tested.
end;


procedure TTestTIUtils.tiIsFileNameValid;
begin
  Check(not tiUtils.tiIsFileNameValid(''), '<empty string>');
  Check(tiUtils.tiIsFileNameValid('a'), 'a');
  Check(tiUtils.tiIsFileNameValid(tiUtils.tiReplicate('a', 255)), tiUtils.tiReplicate('a', 255));
  Check(not tiUtils.tiIsFileNameValid(tiUtils.tiReplicate('a', 256)), tiUtils.tiReplicate('a', 256));
  Check(not tiUtils.tiIsFileNameValid('test\'), 'test\');
  Check(not tiUtils.tiIsFileNameValid('test/'), 'test/');
  Check(not tiUtils.tiIsFileNameValid('test:'), 'test:');
  Check(not tiUtils.tiIsFileNameValid('test*'), 'test*');
  Check(not tiUtils.tiIsFileNameValid('test?'), 'test?');
  Check(not tiUtils.tiIsFileNameValid('test"'), 'test"');
  Check(not tiUtils.tiIsFileNameValid('test>'), 'test>');
  Check(not tiUtils.tiIsFileNameValid('test<'), 'test<');
  Check(not tiUtils.tiIsFileNameValid('test|'), 'test|');
end;


procedure TTestTIUtils.tiCheckSum;
begin
  Check(tiUtils.tiCheckSum('0') = 0, 'CheckSum of "0" <> 0');
  Check(tiUtils.tiCheckSum('01') = 9, 'CheckSum of "01" <> 9');
  Check(tiUtils.tiCheckSum('10') = 7, 'CheckSum of "10" <> 7');
  // non-numeric chars should be treated as zero
  Check(tiUtils.tiCheckSum('1A3') = 8, 'CheckSum of "1A3" <> 8');
  Check(tiUtils.tiCheckSum('DEF67') = 3, 'CheckSum of "DEF67" <> 3');
  Check(tiUtils.tiCheckSum('08137919805') = 5, 'CheckSum of "08137919805" <> 5');
end;


procedure TTestTIUtils.tiJoinPath;
begin
  CheckEquals('',   tiUtils.tiJoinPath('', ''), 'Failed on 1');
  CheckEquals('c:', tiUtils.tiJoinPath('c:\', ''), 'Failed on 2');
  CheckEquals(tiFixPathDelim('c:\windows'), tiUtils.tiJoinPath('c:', 'windows'), 'Failed on 3');
  CheckEquals(tiFixPathDelim('c:\windows'), tiUtils.tiJoinPath('c:', 'windows\'), 'Failed on 4');
  CheckEquals(tiFixPathDelim('c:\windows'), tiUtils.tiJoinPath(['c:','windows']), 'Failed on 5');

  CheckEquals(tiFixPathDelim('\\server\path\documents and settings\user\desktop'),
              tiUtils.tiJoinPath(['\\server\path', 'documents and settings', 'user\desktop\']), 'Failed on 6');

  CheckEquals(tiFixPathDelim('c:\windows\system32'), tiUtils.tiJoinPath(['c:\windows', 'system32']), 'Failed on 7');
  CheckEquals(tiFixPathDelim('c:\windows\system32'), tiUtils.tiJoinPath(['c:', 'windows', 'system32']), 'Failed on 8');

  CheckEquals('',   tiUtils.tiJoinPath([]), 'Failed on 9');
  CheckEquals('',   tiUtils.tiJoinPath(['']), 'Failed on 10');
  CheckEquals(tiFixPathDelim('c:\windows'),   tiUtils.tiJoinPath(['c:\windows\']), 'Failed on 11');
  CheckEquals(tiFixPathDelim('c:\windows'),   tiUtils.tiJoinPath(['c:\windows']), 'Failed on 12');
  CheckEquals('',   tiUtils.tiJoinPath(['\']), 'Failed on 13');
end;


procedure TTestTIUtils.tiStreamToString1;
var
  lStream : TStringStream;
  lsFrom : string;
  lsTo : string;
begin
  lsFrom := tiCreateStringOfSize(3000);
  lStream := TStringStream.Create(lsFrom);
  try
    lsTo := tiUtils.tiStreamToString(lStream);
    CheckEquals(lsFrom, lsTo);
  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiStreamToString2;
var
  LStream : TStringStream;
  LFrom : string;
  LTo : string;
begin
  //                  10
  //        0123456789012
  LFrom := 'abcDEFG012345';
  LStream := TStringStream.Create(LFrom);
  try
    LTo:= tiUtils.tiStreamToString(LStream, 0, 0);
    CheckEquals('a', LTo, 'Failed on 1');

    LTo:= tiUtils.tiStreamToString(LStream, 0, 1);
    CheckEquals('ab', LTo, 'Failed on 2');

    LTo:= tiUtils.tiStreamToString(LStream, 0, 2);
    CheckEquals('abc', LTo, 'Failed on 3');

    LTo:= tiUtils.tiStreamToString(LStream, 3, 6);
    CheckEquals('DEFG', LTo, 'Failed on 4');

    LTo:= tiUtils.tiStreamToString(LStream, 7, 12);
    CheckEquals('012345', LTo, 'Failed on 5');

    LTo:= tiUtils.tiStreamToString(LStream, 9, 100);
    CheckEquals('2345', LTo, 'Failed on 6');

    LTo:= tiUtils.tiStreamToString(LStream, 13, 15);
    CheckEquals('', LTo, 'Failed on 7');

    LStream.Size:= 0;
    LTo:= tiUtils.tiStreamToString(LStream, 0, 0);
    CheckEquals('', LTo, 'Failed on 8');

    LTo:= tiUtils.tiStreamToString(LStream, 1, 2);
    CheckEquals('', LTo, 'Failed on 9');

    try
      tiUtils.tiStreamToString(LStream, 1, 0);
      Fail('Exception not raised');
    except
      on e:Exception do
        CheckIs(e, EAssertionFailed, 'Failed on 10');
    end;

  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiStreamToFile;
var
  lSt: TStringStream;
  LSFrom: string;
  LSTo: string;
  lFileName: string;
const
  cPos = 10;
begin
  ForceDirectories(TempDirectory);
  LSFrom := tiCreateStringOfSize(3000);
  lSt := TStringStream.Create(LSFrom);
  try
    lFileName := TempFileName('tiStreamToFile.txt');
    lSt.Position := cPos;
    tiUtils.tiStreamToFile(lFileName, lSt);
    CheckEquals(cPos, lSt.Position);
  finally
    lSt.Free;
  end;
  LSTo:=tiUtils.tiFileToString(lFileName);
  CheckEquals(LSFrom, LSTo);
end;


procedure TTestTIUtils.tiFileToStream;
var
  lSt: TStringStream;
  lS: string;
  lFileName: string;
  lsl: TStringList;
begin
  ForceDirectories(TempDirectory);
  ls := tiCreateStringOfSize(3000);
  lSt := TStringStream.Create(ls);
  try
    lFileName := TempFileName('tiStreamToFile.txt');
    lsl:= TStringList.Create;
    try
      lsl.Text := ls;
      lsl.SaveToFile(lFileName);
    finally
      lsl.Free;
    end;
    tiUtils.tiFileToStream(lFileName, lSt);
    CheckEquals(lS + cLineEnding, lSt.DataString);
  finally
    lSt.Free;
  end;
end;


procedure TTestTIUtils.tiCopyStream;
var
  ls: string;
  lS1: TStringStream;
  lS2: TStringStream;
begin
  ls := BuildLongString;
  lS1:= TStringStream.Create(ls);
  try
    lS2:= TStringStream.Create('');
    try
      tiUtils.tiCopyStream(lS1, lS2);
      CheckEquals(lS1.DataString, lS2.DataString);
      CheckEquals(0, lS1.Position);
      CheckEquals(0, lS2.Position);
    finally
      lS2.Free;
    end;
  finally
    lS1.Free;
  end;
end;


procedure TTestTIUtils.tiStringToStream;
var
  lStream : TStringStream;
  lsFrom : string;
  lsTo : string;
begin
  lsFrom := tiCreateStringOfSize(3000);
  lStream := TStringStream.Create('');
  try
    tiUtils.tiStringToStream(lsFrom, lStream);
    lsTo := lStream.DataString;
    CheckEquals(lsFrom, lsTo);
  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiAppendStringToStream;
var
  lStream : TStringStream;
  lsFrom : string;
  lsTo : string;
  lsStart: string;
begin
  lsStart := 'aaa';
  lsFrom := 'bbb';
  lStream := TStringStream.Create(lsStart);
  try
    tiUtils.tiAppendStringToStream(lsFrom, lStream);
    lsTo := lStream.DataString;
    CheckEquals(lsStart + lsFrom, lsTo);
  finally
    lStream.Free;
  end;

  lsStart := tiCreateStringOfSize(1000);
  lsFrom := tiCreateStringOfSize(3000);
  lStream := TStringStream.Create(lsStart);
  try
    tiUtils.tiAppendStringToStream(lsFrom, lStream);
    lsTo := lStream.DataString;
    CheckEquals(lsStart + lsFrom, lsTo);
  finally
    lStream.Free;
  end;
end;


procedure TTestTIUtils.tiInsertStringToStream;
var
  LStream : TStringStream;
  LS: string;
begin

  LStream := TStringStream.Create('');
  try
    tiUtils.tiInsertStringToStream('abc', LStream, 0);
    LS:= LStream.DataString;
    CheckEquals('abc', LS, 'Failed on 1');
  finally
    LStream.Free;
  end;

  LStream := TStringStream.Create('DEF');
  try
    tiUtils.tiInsertStringToStream('abc', LStream, 0);
    LS:= LStream.DataString;
    CheckEquals('abcDEF', LS, 'Failed on 2');
  finally
    LStream.Free;
  end;

  LStream := TStringStream.Create('abc');
  try
    tiUtils.tiInsertStringToStream('DEF', LStream, 3);
    LS:= LStream.DataString;
    CheckEquals('abcDEF', LS, 'Failed on 3');
  finally
    LStream.Free;
  end;

  LStream := TStringStream.Create('abcghi');
  try
    tiUtils.tiInsertStringToStream('DEF', LStream, 3);
    LS:= LStream.DataString;
    CheckEquals('abcDEFghi', LS, 'Failed on 4');
  finally
    LStream.Free;
  end;

  LStream := TStringStream.Create('abc');
  try
    try
      tiUtils.tiInsertStringToStream('DEF', LStream, 4);
      fail('Exception not raised');
    except
      on e:Exception do
        CheckIs(E, EAssertionFailed, 'Failed on 5');
    end;
  finally
    LStream.Free;
  end;
end;


procedure TTestTIUtils.tiEncodeDecodeWordBase26;
var
  i  : Integer;
  ls : String;
  li : Integer;
begin
  for i := Low(Word) to (High(Word) div 10) do
  begin
    ls := tiEncodeWordBase26(i);
    li := tiDecodeWordBase26(ls);
    CheckEquals(i, li, 'Failed on ' + IntToStr(i) + ' ' + ls);
  end;
end;


procedure TTestTIUtils.tiForceDirectories;
var
  lDirs: string;
begin
  lDirs := tiFixPathDelim(TempDirectory + '\level1\level2\level3\level4');
  tiUtils.tiForceDirectories(lDirs);
  Check(DirectoryExists(lDirs));
  tiDUnitForceRemoveDir(tiFixPathDelim(TempDirectory + '\level1\'));
end;


procedure TTestTIUtils.tiTestStreamsIdentical;
var
  ls: string;
  lS1: TMemoryStream;
  lS2: TMemoryStream;
begin
  ls := BuildLongString;
  lS1:= TMemoryStream.Create;
  try
    lS2:= TMemoryStream.Create;
    try
      tiUtils.tiStringToStream(ls, lS1);
      tiUtils.tiStringToStream(ls, lS2);
      Check(tiUtils.tiTestStreamsIdentical(lS1, lS2), '#1');
      lS2.Position := 0;
      lS2.Position := 1;
      Check(not tiUtils.tiTestStreamsIdentical(lS1, lS2), '#2');
      ls := 'X' + Copy(ls, 2, Length(ls));
      tiUtils.tiStringToStream(ls, lS2);
      Check(not tiUtils.tiTestStreamsIdentical(lS1, lS2), '#2');
    finally
      lS2.Free;
    end;
  finally
    lS1.Free;
  end;
end;


procedure TTestTIUtils.tiDateWithinRange;
var
  lD, lDFrom, lDTo: TDateTime;
begin
  lDFrom := EncodeDate(2005, 06, 01);
  lDTo := EncodeDate(2005, 06, 03);

  // On lower limit
  lD := EncodeDate(2005, 06, 01);
  Check(tiUtils.tiDateWithinRange(lD, lDFrom, lDTo), '#1');

  // Inside range
  lD := EncodeDate(2005, 06, 02);
  Check(tiUtils.tiDateWithinRange(lD, lDFrom, lDTo), '#2');

  // On upper limit
  lD := EncodeDate(2005, 06, 03);
  Check(tiUtils.tiDateWithinRange(lD, lDFrom, lDTo), '#3');

  // Above upper limit
  lD := EncodeDate(2005, 06, 04);
  Check(not tiUtils.tiDateWithinRange(lD, lDFrom, lDTo), '#4');

  // Below lower limit
  lD := EncodeDate(2005, 06, 01) - 1;
  Check(not tiUtils.tiDateWithinRange(lD, lDFrom, lDTo), '#5');

  // On upper limit with time portion
  lD := EncodeDate(2005, 06, 03) + 0.5;
  Check(tiUtils.tiDateWithinRange(lD, lDFrom, lDTo), '#6');
end;


procedure TTestTIUtils.tiIsNearEnough;
begin
  CheckEquals(True, tiUtils.tiIsNearEnough(0.0,  0.0000013));
  CheckEquals(True, tiUtils.tiIsNearEnough(0.0, -0.0000013));

  CheckEquals(True, tiUtils.tiIsNearEnough(39.5620019, 39.5621821, 0.0001));
  CheckEquals(False, tiUtils.tiIsNearEnough(39.5620019, 39.5621821, 0.000001));

  CheckEquals(False, tiUtils.tiIsNearEnough(3.151e20, 1.23e-10));

  CheckEquals(True, tiUtils.tiIsNearEnough(3.141592654e20, 3.141593915e20));
  CheckEquals(True, tiUtils.tiIsNearEnough(3.141592654e-20, 3.141593915e-20));
end;


procedure TTestTIUtils.tiRound;
begin
  CheckEquals(1, tiUtils.tiRound(1));
  CheckEquals(1, tiUtils.tiRound(1.4));
  CheckEquals(2, tiUtils.tiRound(1.5));
  CheckEquals(2, tiUtils.tiRound(1.6));
end;


procedure TTestTIUtils.tiRemoveDirectory;
var
  lDir: string;
  lPath: string;
begin
  lPath := tiFixPathDelim('Level1\Level2\Level3');
  lDir := TempDirectory + PathDelim + lPath;
  CheckEquals(lPath, tiUtils.tiRemoveDirectory(lDir, TempDirectory), '#1');
  CheckEquals(lPath, tiUtils.tiRemoveDirectory(lDir, UpperCase(TempDirectory)), '#2');
  CheckEquals(UpperCase(lPath), tiUtils.tiRemoveDirectory(UpperCase(lDir), TempDirectory), '#3');
end;


procedure TTestTIUtils.tiXCopy;
begin
  {$IFDEF MSWINDOWS}
  ForceDirectories(TempDirectory+'\From\Level1');
  try
    Check(DirectoryExists(TempDirectory+'\From'), '#1');
    Check(DirectoryExists(TempDirectory+'\From\Level1'), '#2');

    tiUtils.tiStringToFile('test', TempDirectory + '\From\File1.txt');
    tiUtils.tiStringToFile('test',TempDirectory+'\From\Level1\File2.txt');

    Check(FileExists(TempDirectory+'\From\File1.txt'), '#3');
    Check(FileExists(TempDirectory+'\From\Level1\File2.txt'), '#4');

    tiUtils.tiXCopy(TempDirectory + '\From', TempDirectory+'\To');
    try
      Check(DirectoryExists(TempDirectory+'\To'), '#5');
      Check(DirectoryExists(TempDirectory+'\To\Level1'), '#6');
      Check(FileExists(TempDirectory+'\To\File1.txt'), '#7');
      Check(FileExists(TempDirectory+'\To\Level1\File2.txt'), '#8');
    finally
      tiUtils.tiForceRemoveDir(TempDirectory+'\To');
    end;

  finally
    tiUtils.tiForceRemoveDir(TempDirectory+'\From');
  end;
  {$ENDIF}
  {$IFDEF UNIX}
  ForceDirectories(TempDirectory+'/From/Level1');
  try
    Check(DirectoryExists(TempDirectory+'/From'), '#1');
    Check(DirectoryExists(TempDirectory+'/From/Level1'), '#2');

    tiUtils.tiStringToFile('test', TempDirectory + '/From/File1.txt');
    tiUtils.tiStringToFile('test',TempDirectory+'/From/Level1/File2.txt');

    Check(FileExists(TempDirectory+'/From/File1.txt'), '#3');
    Check(FileExists(TempDirectory+'/From/Level1/File2.txt'), '#4');

    tiUtils.tiXCopy(TempDirectory + '/From', TempDirectory + '/To');
    try
      Check(DirectoryExists(TempDirectory+'/To'), '#5');
      Check(DirectoryExists(TempDirectory+'/To/Level1'), '#6');
      Check(FileExists(TempDirectory+'/To/File1.txt'), '#7');
      Check(FileExists(TempDirectory+'/To/Level1/File2.txt'), '#8');
    finally
      tiUtils.tiForceRemoveDir(TempDirectory+'/To');
    end;

  finally
    tiUtils.tiForceRemoveDir(TempDirectory+'/From');
  end;
  {$ENDIF}
end;


procedure TTestTIUtils.tiStrPos;
var
  lFrom: string;
  lSearch: string;
  lResult: PChar;
  {$IFNDEF FPC}
  i: Integer;
  lTimeOld: Cardinal;
  lTimeNew: Cardinal;
  {$ENDIF}
begin
  lFrom:= 'abc';
  lSearch:= 'b';
  lResult:= tiUtils.tiStrPos(PChar(lFrom), PChar(lSearch));
  CheckEquals('bc', string(lResult));

  lSearch := 'x';
  lResult:= tiUtils.tiStrPos(PChar(lFrom), PChar(lSearch));
  CheckEquals('', string(lResult));

  lFrom:= '';
  lSearch:= '';
  lResult:= tiUtils.tiStrPos(PChar(lFrom), PChar(lSearch));
  CheckEquals('', string(lResult));

  {$IFNDEF FPC}
  lFrom := 'this is a test string that will be parsed for the characters <a>';
  lSearch := '<a>';
  lTimeOld := tiGetTickCount;

  for i := 0 to 5000000 do
    StrPos(PChar(lFrom), PChar(lSearch));
  lTimeOld := tiGetTickCount - lTimeOld;

  lTimeNew := tiGetTickCount;
  for i := 0 to 5000000 do
    tiUtils.tiStrPos(PChar(lFrom), PChar(lSearch));
  lTimeNew := tiGetTickCount - lTimeNew;

  Check(lTimeNew < lTimeOld, Format('It got slower! Old: %d, New: %d', [lTimeOld, lTimeNew]));
  {$ENDIF}
end;


procedure TTestTIUtils.tiIfReal;
begin
  CheckEquals(1.1, tiIf(True, 1.1, 2.2), 0.000001);
  CheckEquals(2.2, tiIf(False, 1.1, 2.2), 0.000001);
end;


procedure TTestTIUtils.tiIfInteger;
begin
  CheckEquals(1, tiIf(True, 1, 2));
  CheckEquals(2, tiIf(False, 1, 2));
end;


procedure TTestTIUtils.tiIfString;
begin
  CheckEquals('1', tiIf(True, '1', '2'));
  CheckEquals('2', tiIf(False, '1', '2'));
end;


procedure TTestTIUtils.tiYearToStartAusFinancialYear;
begin
  CheckEquals(EncodeDate(2004, 07, 01), tiUtils.tiYearToStartAusFinancialYear(2005));
end;


procedure TTestTIUtils.tiYearToEndAusFinancialYear;
begin
  CheckEquals(EncodeDate(2005, 06, 30), tiUtils.tiYearToEndAusFinancialYear(2005));
end;


procedure TTestTIUtils.tiAusFinancialYearToString;
begin
  CheckEquals('2003-2004', tiUtils.tiAusFinancialYearToString(2004));
  CheckEquals('2004-2005', tiUtils.tiAusFinancialYearToString(2005));
end;


procedure TTestTIUtils.tiDateToAusFinancialYear;
begin
  CheckEquals(2005, tiUtils.tiDateToAusFinancialYear(EncodeDate(2004, 12, 31)));
  CheckEquals(2005, tiUtils.tiDateToAusFinancialYear(EncodeDate(2005, 01, 01)));
  CheckEquals(2005, tiUtils.tiDateToAusFinancialYear(EncodeDate(2005, 06, 30)));
  CheckEquals(2006, tiUtils.tiDateToAusFinancialYear(EncodeDate(2005, 07, 01)));
end;


procedure TTestTIUtils.tiDeleteFiles;
var
  Lsl : TStringList;
  LTempPath : string;
begin
  lTempPath := TempFileName('tiDeleteFiles');
  ForceDirectories(LTempPath);
  try
    tiUtils.tiStringToFile('test', tiFixPathDelim(LTempPath + '\File1.abc'));
    tiUtils.tiStringToFile('test', tiFixPathDelim(LTempPath + '\File2.abc'));
    tiUtils.tiStringToFile('test', tiFixPathDelim(LTempPath + '\File3.def'));

    Lsl := TStringList.Create;
    try
      tiUtils.tiFilesToStringList(tiFixPathDelim(lTempPath + '\'), AllFilesWildCard, lsl, true);
      CheckEquals(3, lsl.Count);
    finally
      lsl.Free;
    end;

    tiUtils.tiDeleteFiles(LTempPath, '*.abc');

    Check(DirectoryExists(LTempPath));
    Lsl := TStringList.Create;
    try
      tiUtils.tiFilesToStringList(tiFixPathDelim(lTempPath + '\'), AllFilesWildCard, lsl, true);
      CheckEquals(1, lsl.Count);
    finally
      lsl.Free;
    end;
  finally
    tiDUnitForceRemoveDir(lTempPath);
  end;
end;


procedure TTestTIUtils.tiIntegerList;
var
  L: TtiIntegerList;
  i: Integer;
  LCount: Integer;
  LExpected: Integer;
  LLow: Integer;
  LHigh: Integer;
begin
  LLow:= Low(ShortInt);
  LHigh:= High(ShortInt);
  LCount:= LHigh - LLow + 1;
  L:= TtiIntegerList.Create;
  try
    for i := LLow to LHigh do
      L.Add(i);
    CheckEquals(LCount, L.Count);
    for LExpected := LLow to LHigh do
      Check(L.IndexOf(LExpected) <> -1);

    LExpected:= LLow;
    for i := 0 to LCount-1 do
    begin
      CheckEquals(LExpected, L.Items[i]);
      Inc(LExpected);
    end;

    for i := LLow to LHigh do
      L.Remove(i);
    CheckEquals(0, L.Count);

  finally
    L.Free;
  end;
end;


procedure TTestTIUtils.tiDateTimeAsIntlDateDisp;
var
  dt: TDateTime;
begin
  dt := EncodeDate(2006, 1, 18) + EncodeTime(15, 19, 22, 0);
  CheckEquals('2006-01-18 15:19:22', tiUtils.tiDateTimeAsIntlDateDisp(dt), 'Failed on 1');

  dt := EncodeDate(2002, 1, 02) + EncodeTime(12, 34, 56, 12);
  CheckEquals('2002-01-02 12:34:56', tiUtils.tiDateTimeAsIntlDateDisp(dt), 'Failed on 2');

  dt := EncodeDate(2006, 1, 18);
  CheckEquals('2006-01-18 00:00:00', tiUtils.tiDateTimeAsIntlDateDisp(dt), 'Failed on 3');

  dt := EncodeTime(9, 10, 41, 22);
  CheckEquals('0000-00-00 09:10:41', tiUtils.tiDateTimeAsIntlDateDisp(dt), 'Failed on 4');

  {$IFDEF FPCx}
  dt := EncodeDateTime(1652, 6, 15, 12, 34, 56, 12);
  CheckEquals('1652-06-15 12:34:56', tiUtils.tiDateTimeAsIntlDateDisp(dt), 'Failed on 5');
  {$ELSE}
  { Due to bug in Delphi's EncodeDateTime with dates smaller that 1899-12-30 we need
    to subtract the two values. TDateTime is a Double and the value 0 = 1899-12-30 }
  dt := EncodeDate(1652, 6, 15) - EncodeTime(12, 34, 56, 12);
  CheckEquals('1652-06-15 12:34:56', tiUtils.tiDateTimeAsIntlDateDisp(dt), 'Failed on 5');
  {$ENDIF}
end;


procedure TTestTIUtils.tiDateTimeAsIntlDateStor;
var
  dt: TDateTime;
begin
  dt := EncodeDate(2006, 1, 18) + EncodeTime(15, 19, 22, 0);
  CheckEquals('20060118T151922', tiUtils.tiDateTimeAsIntlDateStor(dt), 'Failed on 1');

  dt := EncodeDate(2002, 1, 02) + EncodeTime(12, 34, 56, 12);
  CheckEquals('20020102T123456', tiUtils.tiDateTimeAsIntlDateStor(dt), 'Failed on 2');

  dt := EncodeDate(2006, 1, 18);
  CheckEquals('20060118T000000', tiUtils.tiDateTimeAsIntlDateStor(dt), 'Failed on 3');

  dt := EncodeTime(9, 10, 41, 22);
  CheckEquals('00000000T091041', tiUtils.tiDateTimeAsIntlDateStor(dt), 'Failed on 4');

  {$IFDEF FPCx}
  dt := EncodeDateTime(1652, 6, 15, 12, 34, 56, 12);
  CheckEquals('16520615T123456', tiUtils.tiDateTimeAsIntlDateStor(dt), 'Failed on 5');
  {$ELSE}
  { Due to bug in Delphi's EncodeDateTime with dates smaller that 1899-12-30 we need
    to subtract the two values. TDateTime is a Double and the value 0 = 1899-12-30 }
  dt := EncodeDate(1652, 6, 15) - EncodeTime(12, 34, 56, 12);
  CheckEquals('16520615T123456', tiUtils.tiDateTimeAsIntlDateStor(dt), 'Failed on 5');
  {$ENDIF}
end;


procedure TTestTIUtils.tiIntlDateStorAsDateTime;
var
  dt: TDateTime;
begin
  dt := EncodeDate(2006, 1, 18) + EncodeTime(15, 19, 22, 0);
  CheckNearEnough(dt, tiUtils.tiIntlDateStorAsDateTime('20060118T151922'), 'Failed on 1');

  dt := EncodeDate(2006, 1, 18);
  CheckEquals(dt, tiUtils.tiIntlDateStorAsDateTime('20060118T000000'), 'Failed on 2');

  dt := 0;
  CheckEquals(dt, tiUtils.tiIntlDateStorAsDateTime('00000000T000000'), 'Failed on 3');

  dt := EncodeTime(9, 10, 41, 22);
  CheckNearEnough(dt, tiUtils.tiIntlDateStorAsDateTime('00000000T091041'), 'Failed on 4');

  dt := EncodeDate(1652, 6, 15) + EncodeTime(12, 34, 56, 12);
  CheckNearEnough(dt, tiUtils.tiIntlDateStorAsDateTime('16520615T123456'), 'Failed on 5');
end;


procedure TTestTIUtils.tiIntlDateDispAsDateTime;
var
  dt: TDateTime;
begin
  dt := EncodeDate(2006, 1, 18) + EncodeTime(15, 19, 22, 0);
  CheckEquals(dt, tiUtils.tiIntlDateDispAsDateTime('2006-01-18 15:19:22'), 'Failed on 1');

  dt := EncodeDate(2006, 1, 18);
  CheckEquals(dt, tiUtils.tiIntlDateDispAsDateTime('2006-01-18 00:00:00'), 'Failed on 2');

  dt := 0;
  CheckEquals(dt, tiUtils.tiIntlDateDispAsDateTime('0000-00-00 00:00:00'), 'Failed on 3');

  dt := EncodeTime(9, 10, 41, 22);
  CheckNearEnough(dt, tiUtils.tiIntlDateDispAsDateTime('0000-00-00 09:10:41'), 'Failed on 4');

  dt := EncodeDate(1652, 6, 15) + EncodeTime(12, 34, 56, 12);
  CheckNearEnough(dt, tiUtils.tiIntlDateDispAsDateTime('1652-06-15 12:34:56'), 'Failed on 5');
end;


procedure TTestTIUtils.tiFixPathDelim_Test;
begin
  { Must use IFDEFs as we are testing the Win32 and Unix platforms. }
  {$IFDEF MSWINDOWS}
  CheckEquals('\test',        tiFixPathDelim('\test'),        'Failed on 1');
  CheckEquals('\test\test',   tiFixPathDelim('\test\test'),   'Failed on 2');
  CheckEquals('\test\test\',  tiFixPathDelim('\test\test\'),  'Failed on 3');
  CheckEquals('test\',        tiFixPathDelim('test\'),        'Failed on 4');
  CheckEquals('\\UNC\test\',  tiFixPathDelim('\\UNC\test\'),  'Failed on 5');
  {$ELSE}
  CheckEquals('/test',        tiFixPathDelim('\test'),        'Failed on 1');
  CheckEquals('/test/test',   tiFixPathDelim('\test\test'),   'Failed on 2');
  CheckEquals('/test/test/',  tiFixPathDelim('\test\test\'),  'Failed on 3');
  CheckEquals('test/',        tiFixPathDelim('test\'),        'Failed on 4');
  {$ENDIF}
end;


procedure TTestTIUtils.TearDown;
begin
  if DirectoryExists(TempDirectory) then
    tiUtils.tiForceRemoveDir(TempDirectory);
  inherited;
end;

end.


