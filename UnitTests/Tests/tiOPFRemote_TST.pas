unit tiOPFRemote_TST;

{$I tiDefines.inc}

interface
uses
   tiQuery_TST
  ,tiQuerySQL_TST
  ,tiOPFTestManager
  ,tiClassToDBMap_TST
  ,tiOID_tst
 ;

const
  cErrorCanNotLoadtiDBProxyServer = 'Can not load tiDBProxyServer'#13'' +
                                    'File location: %s'#13'' +
                                    'Error message: %s';

  // ToDo: cErrorFileNotFound should be a generic exception
  cErrorFileNotFound = 'File not found';

type

  TtiOPFTestSetupDataRemote = class(TtiOPFTestSetupData)
  private
    FHadToLoadServer : boolean;
  public
    constructor Create   ; override;
    destructor  Destroy  ; override;
  end;

  TTestTIPersistenceLayersRemote = class(TTestTIPersistenceLayers)
  protected
    procedure SetUp; override;
  end;

  TTestTIDatabaseRemote = class(TTestTIDatabase)
  protected
    procedure SetUp; override;
  published
    procedure DatabaseExists; override;
    procedure CreateDatabase; override;
    procedure Transaction_TimeOut;
  end;

  TTestTIQueryRemote = class(TTestTIQuerySQL)
  protected
    procedure SetUp; override;
  end;

  TTestTIClassToDBMapOperationRemote = class(TTestTIClassToDBMapOperation)
  protected
    procedure   SetUp; override;
  end;

  TTestTIOIDManagerRemote = class(TTestTIOIDManager)
  protected
    procedure   SetUp; override;
  end;

procedure RegisterTests;

implementation
uses
  tiConstants
  ,TestFramework
  ,SysUtils
  ,tiUtils
  ,tiDUnitDependencies
  ,tiQuery
  ,Windows
  ,Messages
  ,tiDialogs
  ,tiTestFramework
 ;

const
  cRemoteServerMainFormName = 'TFormMainTIDBProxyServer';

procedure RegisterTests;
begin
  if gTIOPFTestManager.ToRun(cTIPersistRemote) then
  begin
    RegisterTest(PersistentSuiteName(cTIPersistRemote), TTestTIPersistenceLayersRemote.Suite);
    RegisterTest(PersistentSuiteName(cTIPersistRemote), TTestTIDatabaseRemote.Suite);
    RegisterTest(PersistentSuiteName(cTIPersistRemote), TTestTIQueryRemote.Suite);
    RegisterTest(PersistentSuiteName(cTIPersistRemote), TTestTIOIDManagerRemote.Suite);
    RegisterTest(PersistentSuiteName(cTIPersistRemote), TTestTIClassToDBMapOperationRemote.Suite);
  end;
end;

{ TtiOPFTestSetupDataRemote }

constructor TtiOPFTestSetupDataRemote.Create;
begin
  inherited;
  FHadToLoadServer := false;
  {$IFNDEF STATIC_PERLAYER_LINKING}
    FEnabled := True;
  {$ELSE}
    {$IFDEF LINK_REMOTE}
      FEnabled := True;
    {$ELSE}
      FEnabled := False;
    {$ENDIF}
  {$ENDIF}
  FSelected:= FEnabled;
  FPerLayerName := cTIPersistRemote;
  FDBName  := ReadFromReg(cTIPersistRemote, 'DBName',    cLocalHost);
  FUsername := ReadFromReg(cTIPersistRemote, 'Username', 'null'   );
  FPassword := ReadFromReg(cTIPersistRemote, 'Password', 'null');
  FCanCreateDatabase := false;
  ForceTestDataDirectory;
end;

{ TTestTIDatabaseRemote }

procedure TTestTIDatabaseRemote.CreateDatabase;
begin
  try
    FDatabaseClass.CreateDatabase(PerFrameworkSetup.DBName, PerFrameworkSetup.Username, PerFrameworkSetup.Password);
    Fail('Exception not raised when it should have been');
  except
    on e:exception do
    begin
      CheckIs(e, EAssertionFailed);
      Check(Pos('CreateDatabase not implemented in ' + FDatabaseClass.ClassName, e.Message)<>0);
    end;
  end;
end;

procedure TTestTIDatabaseRemote.DatabaseExists;
begin
  try
    FDatabaseClass.DatabaseExists(PerFrameworkSetup.DBName, PerFrameworkSetup.Username, PerFrameworkSetup.Password);
    Fail('Exception not raised when it should have been');
  except
    on e:exception do
    begin
      CheckIs(e, EAssertionFailed);
      Check(Pos('DatabaseExists not implemented in ' + FDatabaseClass.ClassName, e.Message)<>0);
    end;
  end;
end;

destructor TtiOPFTestSetupDataRemote.Destroy;
var
  lHandle : THandle;
begin
  lHandle := FindWindow(nil, pchar(cRemoteServerMainFormCaption));
  if FHadToLoadServer and (lHandle <> 0) then
    PostMessage(lHandle, WM_Quit, 0, 0);
  inherited;
end;

procedure TTestTIDatabaseRemote.SetUp;
begin
  PerFrameworkSetup:= gTIOPFTestManager.FindByPerLayerName(cTIPersistRemote);
  inherited;
end;

procedure TTestTIDatabaseRemote.Transaction_TimeOut;
var
  lQuery : TtiQuery;
begin
  FDatabase.Connect(PerFrameworkSetup.DBName,
                     PerFrameworkSetup.UserName,
                     PerFrameworkSetup.Password,
                     '');
  try FDatabase.DropTable(cTableNameTestGroup) except end;

  CreateTableTestGroup(FDatabase);

  FDatabase.StartTransaction;
  try
    InsertIntoTestGroup(FDatabase, 1);
    FDatabase.Commit;
    lQuery := FRegPerLayer.tiQueryClass.Create;
    try
      lQuery.AttachDatabase(FDatabase);
      FDatabase.StartTransaction;
      lQuery.SelectRow(cTableNameTestGroup, nil);
      Check(not lQuery.EOF, 'Transaction not committed');
      lQuery.Next;
      Check(lQuery.EOF, 'Wrong number of records');
      Sleep(Trunc(cDBProxyServerTimeOut * 60000 * 1.5));
      try
        FDatabase.Commit;
        Fail('tiDBProxyServer did not time out as expected');
      except
        on e:exception do
          Check(Pos('TIMED OUT', UpperCase(e.message)) <> 0,
                 'tiDBProxyServer did not raise the right exception. Exception message: ' + e.message);
      end;
    finally
      lQuery.Free;
    end;
  finally
    FDatabase.DropTable(cTableNameTestGroup);
  end;
end;

{ TTestTIPersistenceLayersRemote }

procedure TTestTIPersistenceLayersRemote.SetUp;
begin
  PerFrameworkSetup:= gTIOPFTestManager.FindByPerLayerName(cTIPersistRemote);
  inherited;
end;

{ TTestTIQueryRemote }

procedure TTestTIQueryRemote.SetUp;
begin
  PerFrameworkSetup:= gTIOPFTestManager.FindByPerLayerName(cTIPersistRemote);
  inherited;
end;

{ TTestTIClassToDBMapOperationRemote }

procedure TTestTIClassToDBMapOperationRemote.SetUp;
begin
  PerFrameworkSetup:= gTIOPFTestManager.FindByPerLayerName(cTIPersistRemote);
  inherited;
end;

{ TTestTIOIDManagerRemote }

procedure TTestTIOIDManagerRemote.SetUp;
begin
  PerFrameworkSetup:= gTIOPFTestManager.FindByPerLayerName(cTIPersistRemote);
  inherited;
end;

end.
