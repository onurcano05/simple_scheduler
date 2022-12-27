unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ActnList, ComCtrls, ExtCtrls, PopupNotifier, Windows, Dos, ShellApi,
  LCLIntf, versiontypes,
  settings, countdown_dialog, Lng, vinfo, GenerateVersionFile,
  StrUtils, Config;

type

  { TForm1 }

  TForm1 = class(TForm)
    Test_Btn: TButton;
    CountDown2_Lbl: TLabel;
    CountDown_Edt: TEdit;
    Hour_Edt: TEdit;
    Hour_Ud: TUpDown;
    Idle2_Lbl: TLabel;
    Idle_Edt: TEdit;
    Idle_Rbtn: TRadioButton;
    Min_Edt: TEdit;
    Min_Ud: TUpDown;
    Start_Btn: TButton;
    Text_Pntf: TPopupNotifier;
    Settings_Btn: TButton;
    Action_Cmbx: TComboBox;
    Action_Lbl: TLabel;
    File_Lbl: TLabel;
    File_Btn: TButton;
    File_Edt: TEdit;
    IdleTimer_Itmr: TIdleTimer;
    Main_Gbx: TGroupBox;
    Parameters_Edt: TEdit;
    Parameters_Lbl: TLabel;
    OneTime_Rbtn: TRadioButton;
    CountDown_Rbtn: TRadioButton;
    Schedule_Rgp: TRadioGroup;
    SelectFile_Dlg: TOpenDialog;
    Status_Lbl: TLabel;
    Separator_Pnl: TPanel;
    Job_Tmr: TTimer;
    procedure CountDown_EdtEditingDone(Sender: TObject);
    procedure CountDown_EdtExit(Sender: TObject);
    procedure CountDown_RbtnChange(Sender: TObject);
    procedure File_EdtEnter(Sender: TObject);
    procedure File_EdtExit(Sender: TObject);
    procedure File_EdtMouseEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure Hour_EdtEditingDone(Sender: TObject);
    procedure Hour_UdClick(Sender: TObject; Button: TUDBtnType);
    procedure IdleTimer_ItmrStopTimer(Sender: TObject);
    procedure Idle_EdtEditingDone(Sender: TObject);
    procedure Idle_RbtnChange(Sender: TObject);
    procedure Min_EdtEditingDone(Sender: TObject);
    procedure Min_UdClick(Sender: TObject; Button: TUDBtnType);
    procedure OneTime_RbtnChange(Sender: TObject);
    procedure Parameters_EdtEnter(Sender: TObject);
    procedure Parameters_EdtExit(Sender: TObject);
    procedure Parameters_EdtMouseEnter(Sender: TObject);
    procedure Test_BtnClick(Sender: TObject);
    procedure Settings_BtnClick(Sender: TObject);
    procedure Action_CmbxChange(Sender: TObject);
    procedure File_BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IdleTimer_ItmrTimer(Sender: TObject);
    procedure Job_TmrStopTimer(Sender: TObject);
    procedure Job_TmrTimer(Sender: TObject);
    procedure Start_BtnClick(Sender: TObject);
    procedure ApplyCommandAsync(Data: IntPtr);
    procedure RunShellExecute(const prog, params:string; shw: Integer);
    function Tokenize(Str: String): String;
    function DeTokenize(Str: String; DeleteChar: Boolean): String;
    function GetTok(Request: String; Count: Integer; Delimiter: Char): String;
    function SetTok(S: String; InsertS: String; Count: Integer; Delimiter: Char): String;
    function TokLen(S: String; D: Char): Byte;

  const
     LogOff   = EWX_LOGOFF   Or EWX_FORCEIFHUNG;
     StandBy  = EWX_POWEROFF Or EWX_FORCEIFHUNG;
     ReBoot   = EWX_REBOOT;   //Or EWX_FORCEIFHUNG;
     ShutDown = EWX_SHUTDOWN; //Or EWX_FORCEIFHUNG;

     ForceLogOff   = EWX_LOGOFF   Or EWX_FORCE;
     ForceStandBy  = EWX_POWEROFF Or EWX_FORCE;
     ForceReBoot   = EWX_REBOOT   Or EWX_FORCE;
     ForceShutDown = EWX_SHUTDOWN Or EWX_FORCE;

private
    VerStr: ShortString;
    CurrentDir: String;
    _appDataDir: String;
    SettingsPath: String;
    VersionPath: String;
    FActionType: Byte;
    FActionText: String;
    FTimeChosen: TTime;
    FScheduleType: ShortString;
    FCountDownNum: Integer;
    SettingsFrm: TSettings_Frm;
    CountDownFrm: TCountdownDialog_Frm;
    TimeOut: String;
    DefaultLanguage: ShortString;
    CurrentLanguage: ShortString;
    FCounter: PtrInt;
    Ver: LongWord;
    PrevHour: ShortString;
    PrevMin: ShortString;
    PrevCountDown: ShortString;
    PrevIdle: ShortString;
    // Dil değişkenleri

    procedure DisableProgramTextBoxes;
    procedure EnableProgramTextBoxes;
    procedure WarnHandler;
    procedure SaveConfig;
    procedure SetButtonsColorsBoxes;
    procedure EnableDisableControls(EnableRequest: Boolean);
    procedure RunUpdaterAsync(Data: IntPtr);
    procedure ResetTextColors;
    procedure GenerateSettingsFile;
    procedure CheckHourBox;
    procedure CheckMinBox;
    procedure CheckCountdownBox;
    procedure CheckIdleBox;
    function AddLeadingZero(Sender: TObject; const Value: String): String;
    function RemoveLeadingZero(const Value: string): string;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.RunShellExecute(const prog, params:string; shw: Integer);
var
  LanguageUnit: TLanguageUnit1;
begin
  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  //  ( Handle, nil/'open'/'edit'/'find'/'explore'/'print',   // 'open' isn't always needed
  //      path+prog, params, working folder,
  //        0=hide / 1=SW_SHOWNORMAL / 3=max / 7=min)   // for SW_ constants : uses ... Windows ...
  if ShellExecute(0,'open',PChar(prog),PChar(params),PChar(extractfilepath(prog)),shw) >32 then
  begin //success
  end
  else
  begin // return values 0..32 are errors
    Application.MessageBox(PChar(LanguageUnit.ShellExecuteErrorPrefix + SysErrorMessage(GetLastError)),
    PChar(LanguageUnit.ShellExecuteErrorTitle), MB_ICONERROR);
  end;
end;

function ExitWin(lwParam: LongWord): Boolean;
var
 hToken  : THandle;
 TP,TPx  : TTokenPrivileges;
 dwTPrev : DWORD;
 dwTPReq : DWORD;
 booToken: Boolean;
const
 ShutDownName = 'SeShutdownPrivilege';
begin
  Result:= False;

  If Win32Platform = VER_PLATFORM_WIN32_NT
  Then
   Begin
    booToken:= OpenProcessToken(GetCurrentProcess(),
     TOKEN_ADJUST_PRIVILEGES Or TOKEN_QUERY, hToken);

    If booToken
    Then
     Begin
       try
         booToken:= LookupPrivilegeValue
         (Nil, ShutDownName, TP.Privileges[0].LuID);

        TP.PrivilegeCount:= 1;
        TP.Privileges[0].Attributes:= SE_PRIVILEGE_ENABLED;
        dwTPrev:= SizeOf(TPx);
        dwTPReq:= 0;

        If booToken
        Then
         Begin
          Windows.AdjustTokenPrivileges
           (hToken, False, TP, dwTPrev, TPx, dwTPReq);

          If ExitWindowsEx(lwParam, 0)
          Then Result:= True;

          CloseHandle(hToken);
         End;
       finally
         FreeAndNil(booToken);
       end;
     End;
   End;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  TempNum: LongWord;
  Info: TVersionInfo;

  LanguageUnit: TLanguageUnit1;

  VersionStringList: TStringList;
  Config: PConfig;
begin
  CurrentDir:=GetCurrentDir;
  _appDataDir:=GetEnv('APPDATA') + '\Simple Scheduler';
  SettingsPath:=GetEnv('APPDATA') + '\Simple Scheduler\settings.txt';
  VersionPath:=GetEnv('APPDATA') + '\Simple Scheduler\simple_scheduler_version.txt';

  // -- Ayar dosyası yoksa oluştur --
  If Not DirectoryExists(_appDataDir) then
  begin
    ShowMessage('Settings file not found, creating a new one.');
    If Not CreateDir (_appDataDir) Then
    begin
      ShowMessage ('Could not create settings directory');
      Halt;
    end;
  end;

  if Not (FileExists(SettingsPath)) then
  begin
    GenerateSettingsFile;
  end;
  // ---------------------------------------------------------------

  New(Config);
  Config^:=TConfig.Create(nil, settingsPath, '\');

  Info:=TVersionInfo.Create;
  Info.Load(HINSTANCE);
  // Sadece mimari sayısını al
  // https://forum.lazarus.freepascal.org/index.php/topic,12435.0.html
  // http://free-pascal-general.1045716.n5.nabble.com/Comparing-version-numbers-td2811306.html
  TempNum:=Info.FixedInfo.FileVersion[0]; // Major
  VerStr:=IntToStr(TempNum);
  Ver:=10000*TempNum;
  TempNum:=Info.FixedInfo.FileVersion[1]; // Minor
  VerStr:=VerStr+'.'+IntToStr(TempNum);
  Ver:=100*TempNum+Ver;
  { TempNum:=IntToStr(Info.FixedInfo.FileVersion[2]) // Revision
  VerStr:=VerStr+'.'+TempNum
  Ver:=Ver+10*StrToInt(TempNum) }
  TempNum:=Info.FixedInfo.FileVersion[3]; // Build
  VerStr:=VerStr+' Build '+IntToStr(TempNum);
  Ver:=TempNum+Ver;
  Info.Free;

  // Sürüm txt dosyasını oluştur
  try
    VersionStringList:=TStringList.Create;
    VersionStringList.Sorted:=False;
  except
    raise Exception.Create('Version file not found.')
  end;

  VersionStringList.Add('VersionNum=' + Ver.ToString);
  VersionStringList.Add('Url=https://rock55.neocities.org/simple_scheduler_version.txt');
  VersionStringList.Add('AlternativeUrl=https://rock55.neocities.org/simple_scheduler_version.txt');
  VersionStringList.Add('FileVersion=' + VerStr);
  VersionStringList.Add('DatePublished=' + DateTimeToStr(Now));

  VersionStringList.SaveToFile(GetEnv('appdata') + '\Simple Scheduler\simple_scheduler_version.txt');

  //----------------------------------------------------------------------------

  LanguageUnit:=TLanguageUnit1.Create;

  try
    DefaultLanguage:=Config^.ReadTextFile('language');
    CurrentLanguage:=DefaultLanguage;
    LanguageUnit.CurrentLanguage:=CurrentLanguage;

    LanguageUnit.DefaultLanguage:=DefaultLanguage;
    SettingsFrm:=TSettings_Frm.Create(Nil);
    SettingsFrm.DefaultLanguage:=DefaultLanguage;
    LanguageUnit.SetText;
    CountDownFrm:=TCountDownDialog_Frm.Create(Nil);

    Action_Lbl.Caption:=LanguageUnit.ActionLblCaption;
    File_Lbl.Caption:=LanguageUnit.FileLblCaption;
    Parameters_Lbl.Caption:=LanguageUnit.ParametersLblCaption;
    Status_Lbl.Caption:=LanguageUnit.StatusLblCaption;
    Main_Gbx.Caption:=LanguageUnit.MainGbxCaption;
    Schedule_Rgp.Caption:=LanguageUnit.ScheduleRgpCaption;
    Action_Cmbx.Items[0]:=LanguageUnit.ActionCmbxRunAProgram;
    Action_Cmbx.Items[1]:='-';
    Action_Cmbx.Items[2]:=LanguageUnit.ActionCmbxLogOff;
    Action_Cmbx.Items[3]:=LanguageUnit.ActionCmbxStandBy;
    Action_Cmbx.Items[4]:=LanguageUnit.ActionCmbxReboot;
    Action_Cmbx.Items[5]:=LanguageUnit.ActionCmbxShutDown;
    Action_Cmbx.Items[6]:='-';
    Action_Cmbx.Items[7]:=LanguageUnit.ActionCmbxForceLogOff;
    Action_Cmbx.Items[8]:=LanguageUnit.ActionCmbxForceStandBy;
    Action_Cmbx.Items[9]:=LanguageUnit.ActionCmbxForceReboot;
    Action_Cmbx.Items[10]:=LanguageUnit.ActionCmbxForceShutDown;
    OneTime_Rbtn.Caption:=LanguageUnit.OneTimeRbtnCaption;
    CountDown_Rbtn.Caption:=LanguageUnit.CountDownRbtnCaption;
    CountDown2_Lbl.Caption:=LanguageUnit.CountDown2LblCaption;
    Idle_Rbtn.Caption:=LanguageUnit.IdleRbtnCaption;
    Idle2_Lbl.Caption:=LanguageUnit.Idle2LblCaption;
    File_Btn.Caption:=LanguageUnit.SelectBtnCaption;
    Test_Btn.Caption:=LanguageUnit.RunNowBtnCaption;
    Start_Btn.Caption:=LanguageUnit.StartBtnCaption;
    Settings_Btn.Caption:=LanguageUnit.SettingsBtnCaption;
  except
    on E: Exception do
    begin
      raise Exception.Create('Local variables not set. ' + E.Message);
      Config^.Destroy;
      Config:=nil;
      Dispose(Config);
    end;
  end;

  CheckHourBox;

  CheckMinBox;

  CheckCountdownBox;

  CheckIdleBox;

  Config^.Destroy;
  Config:=nil;
  Dispose(Config);
end;

procedure TForm1.IdleTimer_ItmrTimer(Sender: TObject);
var
  LanguageUnit: TLanguageUnit1;
begin
  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  IdleTimer_Itmr.Enabled:=False;
  IdleTimer_Itmr.AutoEnabled:=False;
  Status_Lbl.Caption:=LanguageUnit.StatusLblCaption;
  WarnHandler;
end;

procedure TForm1.Job_TmrStopTimer(Sender: TObject);
var
  LanguageUnit: TLanguageUnit1;
begin
  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  // Durum yazısını değiştir
  Status_Lbl.Caption:=LanguageUnit.StatusLblCaption;
  // Status_Lbl.Font.color:=clDefault;
  SetButtonsColorsBoxes;
end;

procedure TForm1.Job_TmrTimer(Sender: TObject);
var
  RequestedMin:Integer;
begin
  if (OneTime_Rbtn.Checked=True) then // Saat seçiliyse
  begin
    if (StrToDateTime(FormatDateTime('hh:nn', Time))=FTimeChosen) then
    begin
      Job_Tmr.Enabled:=False;
      WarnHandler;
    end;
  end
  else if (CountDown_Rbtn.Checked=True) then // Geri sayım seçiliyse
  begin
    RequestedMin:=StrToInt(CountDown_Edt.Text);
    FCountDownNum:=FCountDownNum+1;
    if (FCountDownNum>=RequestedMin) then
    begin
      Job_Tmr.Enabled:=False;
      WarnHandler;
    end
  end;
end;

procedure TForm1.Action_CmbxChange(Sender: TObject);
begin
  SetButtonsColorsBoxes;
end;

procedure TForm1.Settings_BtnClick(Sender: TObject);
begin
  SettingsFrm.CurrentLanguage:=CurrentLanguage; // Şu anki dili gönder
  SettingsFrm.VerStr:=VerStr;
  SettingsFrm.ShowModal; // Formu aç
end;

procedure TForm1.SaveConfig;
var
  LanguageUnit   : TLanguageUnit1;

  RememberInputs : Boolean;
  Str            : ^String;

  ListOfConfig   : TStringList;

  Config         : PConfig;
begin
  New(Str);
  Str^:='';

  New(Config);
  Config^:=TConfig.Create(nil, SettingsPath, '=');

  ListOfConfig:=TStringList.Create;
  ListOfConfig.Sorted:=False;

  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  RememberInputs:=SettingsFrm.RememberInputs;

  if (RememberInputs=True) then
  begin
    Str^:=Action_Cmbx.ItemIndex.ToString;
    Config^.WriteTextFile(settingsPath, 'action', Str^);

    Str^:=File_Edt.Text;
    Config^.WriteTextFile(settingsPath, 'file', Str^);

    Str^:=Parameters_Edt.Text;
    Config^.WriteTextFile(settingsPath, 'parameters', Str^);

    if (OneTime_Rbtn.Checked=True) then begin Str^:='one time'; end
    else if (CountDown_Rbtn.Checked=True) then begin Str^:='countdown'; end
    else if (Idle_Rbtn.Checked=True) then begin Str^:='idle'; end;
    Config^.WriteTextFile(settingsPath, 'scheduleType', Str^);

    Str^:=Hour_Edt.Text;
    Config^.WriteTextFile(settingsPath, 'oneTimeHour', Str^);

    Str^:=Min_Edt.Text;
    Config^.WriteTextFile(settingsPath, 'oneTimeMin', Str^);

    Str^:=CountDown_Edt.Text;
    Config^.WriteTextFile(settingsPath, 'countDownMin', Str^);

    Str^:=Idle_Edt.Text;
    Config^.WriteTextFile(settingsPath, 'idleMin', Str^);
  end
  else
  begin
    // Hatırlama istenmemişse boş yap ve kaydet
    Config^.WriteTextFile(settingsPath, 'action', '0');
    Config^.WriteTextFile(settingsPath, 'file', '');
    Config^.WriteTextFile(settingsPath, 'parameters', '');
    Config^.WriteTextFile(settingsPath, 'scheduleType', 'one time');
    Config^.WriteTextFile(settingsPath, 'oneTimeHour', '1');
    Config^.WriteTextFile(settingsPath, 'oneTimeMin', '0');
    Config^.WriteTextFile(settingsPath, 'countdownMin', '10');
    Config^.WriteTextFile(settingsPath, 'idleMin', '10');
    Config^.WriteApply;
  end;

  Str:=nil;
  Config^.Destroy;
  Config:=nil;
  Dispose(Config);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  RememberInputs   : Boolean;
  WarnBeforeAction : Boolean;

  Str              : ^String;

  TempNum          : Word;
  Info             : TVersionInfo;
  Config           : PConfig;
begin
  Info:=TVersionInfo.Create;
  Info.Load(HINSTANCE);
  // Sadece mimari sayısını al
  // https://forum.lazarus.freepascal.org/index.php/topic,12435.0.html
  // http://free-pascal-general.1045716.n5.nabble.com/Comparing-version-numbers-td2811306.html
  TempNum:=Info.FixedInfo.FileVersion[0]; // Major
  VerStr:=IntToStr(TempNum);
  TempNum:=Info.FixedInfo.FileVersion[1]; // Minor
  VerStr:=VerStr+'.'+IntToStr(TempNum);
  { TempNum:=IntToStr(Info.FixedInfo.FileVersion[2]) // Revision
  VerStr:=VerStr+'.'+TempNum }
  TempNum:=Info.FixedInfo.FileVersion[3]; // Build
  VerStr:=VerStr+' Build '+IntToStr(TempNum);
  Info.Free;

  Form1.Caption:='Simple Scheduler ' + VerStr;

  New(Str);
  Str^:='';

  New(Config);
  Config^:=TConfig.Create(Nil, SettingsPath, '\');

  // Öntanımlılar
  Action_Cmbx.ItemIndex:=0; // En üsttekini seç
  FActionType:=0; // Program çalıştırma olarak ayarla
  Job_Tmr.Enabled:=False;
  IdleTimer_Itmr.Enabled:=False;
  IdleTimer_Itmr.AutoEnabled:=False;

  // txt dosyasından al
  SettingsFrm.CheckForUpdates:=StrToBool(Config^.ReadTextFile('updates'));
  if (StrToBool(Config^.ReadTextFile('updates')) = True) then
  begin
    FCounter := FCounter+1;
    Application.QueueAsyncCall(@RunUpdaterAsync, FCounter);
  end;

  WarnBeforeAction:=StrToBool(Config^.ReadTextFile('warn'));

  SettingsFrm.WarnBeforeAction:=StrToBool(Config^.ReadTextFile('warn'));

  TimeOut:=Config^.ReadTextFile('warnTimeOut');
  SettingsFrm.TimeOut:=Config^.ReadTextFile('warnTimeOut');


  // Ayarları hatırlama seçildiyse
  if (Config^.ReadTextFile('rememberInputs') = '') then Exit;
  RememberInputs:=StrToBool(Config^.ReadTextFile('rememberInputs'));
  SettingsFrm.RememberInputs:=StrToBool(Config^.ReadTextFile('rememberInputs'));

  if (Config^.ReadTextFile('scheduleType') <> '') then FScheduleType:=Config^.ReadTextFile('scheduleType');

  if (RememberInputs=True) then
  begin
    if (Config^.ReadTextFile('action') <> '') then FActionType:=SizeOf(Config^.ReadTextFile('action'));
    if (FActionType=0) then
    begin
      if (Config^.ReadTextFile('file') <> '') then Str^:=Config^.ReadTextFile('file');
      File_Edt.Text:=Str^;
      if (Config^.ReadTextFile('parameters') <> '') then Str^:=Config^.ReadTextFile('parameters');
      Parameters_Edt.Text:=Str^;
    end
    else // "run a program" harici seciliyse
    begin
      Action_Cmbx.ItemIndex:=FActionType;
      DisableProgramTextBoxes;
    end;

    // Tüm kutuları doldur
    if (Config^.ReadTextFile('oneTimeHour') <> '') then Str^:=Config^.ReadTextFile('oneTimeHour');
    Hour_Edt.Text:=Str^;
    CheckHourBox;

    if (Config^.ReadTextFile('oneTimeMin') <> '') then Str^:=Config^.ReadTextFile('oneTimeMin');
    Min_Edt.Text:=Str^;
    CheckIdleBox;

    if (Config^.ReadTextFile('countdownMin') <> '') then Str^:=Config^.ReadTextFile('countDownMin');
    CountDown_Edt.Text:=Str^;
    CheckCountdownBox;

    if (Config^.ReadTextFile('idleMin') <> '') then Str^:=Config^.ReadTextFile('idleMin');
    Idle_Edt.Text:=Str^;
    CheckIdleBox;
  end;

  if (FScheduleType='one time') then
  begin
    OneTime_Rbtn.Checked:=True;
    SetButtonsColorsBoxes;
  end
  else if (FScheduleType='countdown') then
  begin
    CountDown_Rbtn.Checked:=True;
    SetButtonsColorsBoxes;
  end
  else if (FScheduleType='idle') then
  begin
    Idle_Rbtn.Checked:=True;
    SetButtonsColorsBoxes;
  end;

  Config^.Destroy;
  Config:=nil;
  Dispose(Config);

  {
  // Güncellemeyi kontrol et ve yeni dosyayı sil
  Sleep(10000);
  UpToDatePath:=GetCurrentDir + TempVersionPath;
  if (FileExists(UpToDatePath)) then
  begin
    CompareVersions;
    Sleep(2000);
  end;
  }
end;

procedure TForm1.Hour_EdtEditingDone(Sender: TObject);
begin
  CheckHourBox;
end;

procedure TForm1.Hour_UdClick(Sender: TObject; Button: TUDBtnType);
begin
  Hour_Ud.SetFocus;
  CheckHourBox;
end;

procedure TForm1.IdleTimer_ItmrStopTimer(Sender: TObject);
begin
  // SetButtonsColorsBoxes;
end;

procedure TForm1.File_EdtMouseEnter(Sender: TObject);
var
  Str: String;
begin
  File_Edt.Hint:='';
  Str:=File_Edt.Text;
  if (Str.Length>=19) then
  begin
    File_Edt.Hint:=Str;
    File_Edt.ShowHint:=True;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  VerStr:='';
  CurrentDir:='';
  _appDataDir:='';
  SettingsPath:='';
  VersionPath:='';
  FActionType:=0;
  FActionText:='';
  // FTimeChosen:=nil;
  FScheduleType:='';
  FCountDownNum:=0;
  SettingsFrm:=nil;
  SettingsFrm.Free;
  CountDownFrm:=nil;
  CountDownFrm.Free;
  TimeOut:='';
  DefaultLanguage:='';
  CurrentLanguage:='';
  // FCounter:=0;
  // Ver: LongWord;
  PrevHour:='';
  PrevMin:='';
  PrevCountDown:='';
  PrevIdle:='';
  Form1.Free;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  SaveConfig;
end;

procedure TForm1.CountDown_EdtEditingDone(Sender: TObject);
begin
  CheckCountdownBox;
end;

procedure TForm1.CountDown_EdtExit(Sender: TObject);
begin
  CheckCountdownBox;
end;

procedure TForm1.CountDown_RbtnChange(Sender: TObject);
begin
  // 2. radyo düğmesinin rengini değiştir
  if (CountDown_Rbtn.Checked=True) then
  begin
    SetButtonsColorsBoxes;
  end;
end;

procedure TForm1.File_EdtEnter(Sender: TObject);
begin
  File_Edt.Color:=clDefault;
end;

procedure TForm1.File_EdtExit(Sender: TObject);
begin
  File_Edt.Color:=clBtnFace;
end;

procedure TForm1.Idle_EdtEditingDone(Sender: TObject);
begin
  CheckIdleBox;
end;

procedure TForm1.Idle_RbtnChange(Sender: TObject);
begin
  // 3. radyo düğmesinin rengini değiştir
  if (Idle_Rbtn.Checked=True) then
  begin
    SetButtonsColorsBoxes;
  end;
end;

procedure TForm1.Min_EdtEditingDone(Sender: TObject);
begin
  CheckMinBox;
end;

procedure TForm1.Min_UdClick(Sender: TObject; Button: TUDBtnType);
var
  MinStr: ShortString;
begin
  Min_Ud.SetFocus;
  MinStr:='';
  MinStr:=Min_Edt.Text;
  CheckMinBox;
end;

procedure TForm1.OneTime_RbtnChange(Sender: TObject);
begin
  // 1. radyo düğmesinin rengi değiştir
  if (OneTime_Rbtn.Checked=True) then
  begin
    SetButtonsColorsBoxes;
  end;
end;

procedure TForm1.Parameters_EdtEnter(Sender: TObject);
begin
  Parameters_Edt.Color:=clDefault;
end;

procedure TForm1.Parameters_EdtExit(Sender: TObject);
begin
  Parameters_Edt.Color:=clBtnFace;
end;

procedure TForm1.Parameters_EdtMouseEnter(Sender: TObject);
var Str: String;
begin
  Parameters_Edt.Hint:='';
  Str:=Parameters_Edt.Text;
  if (Str.Length>=19) then
  begin
    Parameters_Edt.Hint:=Str;
    Parameters_Edt.ShowHint:=True;
  end;
end;

procedure TForm1.Test_BtnClick(Sender: TObject);
var
  FileStr: String;
  ParametersStr: String;
begin
  FileStr:=File_Edt.Text;
  ParametersStr:=Parameters_Edt.Text;
  RunShellExecute('"' + FileStr + '"', ParametersStr, 1);
end;

procedure TForm1.File_BtnClick(Sender: TObject);
var
  filename: string;
begin
  if SelectFile_Dlg.Execute then
  begin
    filename := SelectFile_Dlg.Filename;
    File_Edt.Text:=filename;
  end;
end;

procedure TForm1.Start_BtnClick(Sender: TObject);
var
  LanguageUnit: TLanguageUnit1;

  HourStr: ShortString;
  MinStr: ShortString;
  StatusStr: String;
begin
  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  if (SettingsFrm.RememberInputs=True) then
  begin
    SaveConfig;
  end;
  Start_Btn.Enabled:=False;

  // Zaten çalışıyorsa durdur ve fonksiyondan çık
  if (Job_Tmr.Enabled=True) Or (IdleTimer_Itmr.Enabled=True) Or
          (IdleTimer_Itmr.AutoEnabled=True)
  then
  begin
    Job_Tmr.Enabled:=False;
    IdleTimer_Itmr.Enabled:=False;
    IdleTimer_Itmr.AutoEnabled:=False;

    Status_Lbl.Caption:=LanguageUnit.StatusLblCaption;
    CountDownFrm.ActionText:=GetTok(File_Edt.Caption, Toklen(File_Edt.Caption, '\'), '\');

    EnableDisableControls(True);
    // Status_Lbl.Font.color:=clDefault;

    Start_Btn.Enabled:=True;
    SetButtonsColorsBoxes;
    Exit;
  end;

  // Çalıştırma seçiliyse ve yol yoksa uyar
  if (Action_Cmbx.ItemIndex=0) And (File_Edt.Text='') then
  begin
    ShowMessage(LanguageUnit.NullFileMsg);
    Start_Btn.Enabled:=True;
    SetButtonsColorsBoxes;
    Exit;
  end;

  // Hiçbir eylem seçili değilse
  if (Action_Cmbx.ItemIndex=1) Or (Action_Cmbx.ItemIndex=6) then
  begin
    ShowMessage(LanguageUnit.nullActionMsg);
    Start_Btn.Enabled:=True;
    SetButtonsColorsBoxes;
    Exit;
  end;

  // Belli saate çalıştırma
  If (OneTime_Rbtn.Checked=True) Then
  begin
    HourStr:=Hour_Edt.Text;
    MinStr:=Min_Edt.Text;

    FScheduleType:='one time';
    FTimeChosen:=StrToDateTime(HourStr + ':' + MinStr);
    Job_Tmr.Interval:=1000;
    Job_Tmr.Enabled:=True;

    StatusStr:=LanguageUnit.oneTimeStatusStr;
    StatusStr:=StatusStr.Replace('%action%', Action_Cmbx.Text);
    StatusStr:=StatusStr.Replace('%time%',FormatDateTime('hh:nn', FTimeChosen));
    Status_Lbl.Caption:=StatusStr;

    FActionText:=LanguageUnit.oneTimeCountDownDialogStr;
    FActionText:=FActionText.Replace('%action%', Action_Cmbx.Text);
    FActionText:=FActionText.Replace('%time%', FormatDateTime('hh:nn', FTimeChosen));

    Status_Lbl.Caption:=StatusStr;
    CountDownFrm.ActionText:=GetTok(File_Edt.Caption, Toklen(File_Edt.Caption, '\'), '\');

    EnableDisableControls(False);
    // Status_Lbl.Font.color:=clGreen;
  end
  // Geri sayım seçiliyse
  else if (CountDown_Rbtn.Checked=True) Then
  begin
    FScheduleType:='countdown';
    Job_Tmr.Interval:=60000;
    Job_Tmr.Enabled:=True;

    StatusStr:=LanguageUnit.CountDownStatusStr;
    StatusStr:=StatusStr.Replace('%action%', Action_Cmbx.Text);
    StatusStr:=StatusStr.Replace('%countdownnum%', CountDown_Edt.Text);

    FActionText:=LanguageUnit.CountDownCountDownDialogStr;
    FActionText:=FActionText.Replace('%action%', Action_Cmbx.Text);
    FActionText:=FActionText.Replace('%countdownnum%', CountDown_Edt.Text);

    Status_Lbl.Caption:=StatusStr;
    EnableDisableControls(False);
    CountDownFrm.ActionText:=GetTok(File_Edt.Caption, Toklen(File_Edt.Caption, '\'), '\');
    // Status_Lbl.Font.color:=clGreen;
  end
  // Boşta kalma seçiliyse
  else if (Idle_Rbtn.Checked=True) Then
  begin
    FScheduleType:='idle';
    IdleTimer_Itmr.Interval:=StrToInt(Idle_Edt.Text)*60000;
    IdleTimer_Itmr.AutoEnabled:=True;

    StatusStr:=LanguageUnit.idleStatusStr;
    StatusStr:=StatusStr.Replace('%action%', Action_Cmbx.Text);
    StatusStr:=StatusStr.Replace('%idlenum%', Idle_Edt.Text);

    FActionText:=LanguageUnit.idleCountDownDialogStr;
    FActionText:=FActionText.Replace('%action%', Action_Cmbx.Text);
    FActionText:=FActionText.Replace('%idlenum%', Idle_Edt.Text);

    Status_Lbl.Caption:=StatusStr;

    EnableDisableControls(False);
    CountDownFrm.ActionText:=GetTok(File_Edt.Caption, Toklen(File_Edt.Caption, '\'), '\');
    // Status_Lbl.Font.color:=clGreen;
  end;

  // 0'a tamamlanmışsa düzelt
  CheckHourBox;
  CheckMinBox;

  CheckCountdownBox;
  CheckIdleBox;
  Start_Btn.Enabled:=True;

  // Kutu renklerini sıfırla
  ResetTextColors;
end;

procedure TForm1.ApplyCommandAsync(Data: IntPtr);
var
  SelectedIndex:Integer;
begin
  Job_Tmr.Enabled:=False;
  SelectedIndex:=Action_Cmbx.ItemIndex;
  case SelectedIndex of
    0:RunShellExecute(File_Edt.Text, Parameters_Edt.Text, 1);
    1:Exit;
    2:ExitWin(logoff);
    3:ExitWin(standby);
    4:ExitWin(ReBoot);
    5:ExitWin(shutdown);
    6:Exit;
    7:ExitWin(forcelogoff);
    8:ExitWin(forcestandby);
    9:ExitWin(forcereboot);
    10:ExitWin(forceshutdown);
  end;

  Data:=0;

  // Kutuyu renklendir
  SetButtonsColorsBoxes;
end;

procedure TForm1.DisableProgramTextBoxes;
begin
  File_Edt.Enabled:=False;
  File_Btn.Enabled:=False;
  Parameters_Edt.Enabled:=False;
  Test_Btn.Enabled:=False;
end;

procedure TForm1.EnableProgramTextBoxes;
begin
  File_Edt.Enabled:=True;
  File_Btn.Enabled:=True;
  Parameters_Edt.Enabled:=True;
  Test_Btn.Enabled:=True;
end;

procedure TForm1.WarnHandler;
var
  LanguageUnit: TLanguageUnit1;
  WarnBeforeAction: Boolean;
begin
  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  SetButtonsColorsBoxes;
  IdleTimer_Itmr.Enabled:=False;
  IdleTimer_Itmr.AutoEnabled:=False;
  Job_Tmr.Enabled:=False;
  EnableDisableControls(True);

  WarnBeforeAction:=SettingsFrm.WarnBeforeAction;
  CountDownFrm.WarnRequest:=WarnBeforeAction;

  FCounter:=0;

  if (WarnBeforeAction=True) then // Uyarma istendiyse
  begin
    Status_Lbl.Caption:=LanguageUnit.ApprovalStatusStr;

    CountDownFrm.Description:=LanguageUnit.TimeOutDescriptionLblCaption;
    CountDownFrm.ActionText:=GetTok(File_Edt.Caption, Toklen(File_Edt.Caption, '\'), '\');
    CountDownFrm.TimeOut:=SettingsFrm.TimeOut;
    CountDownFrm.YesBtnCaption:=LanguageUnit.YesBtnCaption;
    CountDownFrm.NoBtnCaption:=LanguageUnit.NoBtnCaption;
    Application.Restore; // unminimize window, makes no harm always call it

    //Pencereyi öne getir
    SetWindowPos(self.Handle, HWND_NOTOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
    SetWindowPos(self.Handle, HWND_TOPMOST,0,0,0,0, SWP_NOMOVE or SWP_NOSIZE);
    SetWindowPos(self.Handle, HWND_NOTOPMOST,0,0,0,0, SWP_SHOWWINDOW or SWP_NOMOVE or SWP_NOSIZE);

    // Formu aç
    CountDownFrm.ShowModal;
    if (CountDownFrm.ModalResult=mrYes) then // Evet döndürürse komutu çalıştır
    begin
      FCounter:=FCounter + 1;
      Application.QueueAsyncCall(@ApplyCommandAsync, FCounter);
    end
    else // Evet döndürmezse çık
    begin
      Exit;
    end;
  end
  else
  begin
    FCounter:=FCounter + 1;
    Application.QueueAsyncCall(@ApplyCommandAsync, FCounter);
  end;

  Status_Lbl.Caption:=LanguageUnit.StatusLblCaption;
end;

procedure TForm1.SetButtonsColorsBoxes;
begin
  ResetTextColors;

  // Kutuları renklendir
  if (OneTime_Rbtn.Checked=True) then
  begin
    Hour_Edt.Color:=clDefault;
    Min_Edt.Color:=clDefault;
  end
  else if (CountDown_Rbtn.Checked=True) then
  begin
    CountDown_Edt.Color:=clDefault;
  end
  else if (Idle_Rbtn.Checked=True) then
  begin
    Idle_Edt.Color:=clDefault;
  end;

  // Kutular ve düğmeler etkin /etkisiz
  if (Action_Cmbx.ItemIndex=0) then
  begin
    EnableProgramTextBoxes;
  end
  else
  begin
    DisableProgramTextBoxes;
  end;
end;

procedure TForm1.EnableDisableControls(EnableRequest: Boolean);
begin
  if (Action_Cmbx.ItemIndex=0) then
  begin
    File_Edt.Enabled:=EnableRequest;
    Parameters_Edt.Enabled:=EnableRequest;
  end;

  Action_Lbl.Enabled:=EnableRequest;
  File_Lbl.Enabled:=EnableRequest;
  Parameters_Lbl.Enabled:=EnableRequest;
  Action_Cmbx.Enabled:=EnableRequest;
  File_Btn.Enabled:=EnableRequest;
  Test_Btn.Enabled:=EnableRequest;
  Hour_Edt.Enabled:=EnableRequest;
  Min_Edt.Enabled:=EnableRequest;
  Hour_Ud.Enabled:=EnableRequest;
  Min_Ud.Enabled:=EnableRequest;
  OneTime_Rbtn.Enabled:=EnableRequest;
  CountDown_Rbtn.Enabled:=EnableRequest;
  CountDown_Edt.Enabled:=EnableRequest;
  CountDown2_Lbl.Enabled:=EnableRequest;
  Idle_Rbtn.Enabled:=EnableRequest;
  Idle_Edt.Enabled:=EnableRequest;
  Idle2_Lbl.Enabled:=EnableRequest;
end;

procedure TForm1.RunUpdaterAsync(Data: IntPtr);
begin
  RunShellExecute('updatecheck.exe', '', 1);
  Data:=0;
end;

procedure TForm1.ResetTextColors;
begin
  File_Edt.Color:=clBtnFace;
  Parameters_Edt.Color:=clBtnFace;

  Hour_Edt.Color:=clBtnFace;
  Min_Edt.Color:=clBtnFace;
  CountDown_Edt.Color:=clBtnFace;
  Idle_Edt.Color:=clBtnFace;
end;

procedure TForm1.GenerateSettingsFile;
var
  ListOfConfig: TStringList;
begin
  ListOfConfig:=TStringList.Create;
  ListOfConfig.Sorted:=False;

  ListOfConfig.Add('updates=-1');
  ListOfConfig.Add('rememberInputs=0');
  ListOfConfig.Add('warn=0');
  ListOfConfig.Add('action=0');
  ListOfConfig.Add('file=');
  ListOfConfig.Add('parameters=');
  ListOfConfig.Add('scheduleType=one time');
  ListOfConfig.Add('oneTimeHour=1');
  ListOfConfig.Add('oneTimeMin=0');
  ListOfConfig.Add('countDownMin=10');
  ListOfConfig.Add('idleMin=10');
  ListOfConfig.Add('warnTimeOut=45');
  ListOfConfig.Add('language=english');

  ListOfConfig.SaveToFile(settingsPath, TEncoding.UTF8);

  ListOfConfig:=nil;
  ListOfConfig.Free;
end;

procedure TForm1.CheckHourBox;
var
  HourStr: ShortString;
begin
  // Boş ise sayıyı geri döndür
  if (Hour_Edt.Text = '') then
  begin
    Hour_Edt.Text:=PrevHour;
  end;

  // 24'ü aşarsa sayıyı geri döndür
  if (StrToInt(Hour_Edt.Text) >= 24) then
  begin
    Hour_Edt.Text:=PrevHour;
  end;

  // Sayıyı hafızada tut
  PrevHour:=Hour_Edt.Text;

  // Öne sıfır ekle ve tamamla
  HourStr:='null';
  HourStr:=AddLeadingZero(Hour_Edt, HourStr);

  // Kutuya yaz
  Hour_Edt.Text:=HourStr;
end;

procedure TForm1.CheckMinBox;
var
  MinStr: ShortString;
begin
  // Boş ise sayıyı geri döndür
  if (Min_Edt.Text = '') then
  begin
    Min_Edt.Text:=PrevMin;
  end;

  // 60'u aşarsa sayıyı geri döndür
  if (StrToInt(Min_Edt.Text) >= 60) then
  begin
    Min_Edt.Text:=PrevMin;
  end;

  // Şu anki sayıyı hafızada tut
  PrevMin:=Min_Edt.Text;

  // Öne sıfır ekle
  MinStr:='null';
  MinStr:=AddLeadingZero(Min_Edt, MinStr);

  // Kutuya yaz
  Min_Edt.Text:=MinStr;
end;

procedure TForm1.CheckCountDownBox;
var
  CountDownStr: ShortString;
begin
  // Boş eskiye döndür
  if (CountDown_Edt.Text='') then
  begin
    CountDown_Edt.Text:=PrevCountDown;
  end;

  // Yanlış ise eskiye döndür

  // Şu anki sayıyı hafızada tut
  PrevCountDown:=Countdown_Edt.Text;

  // Dizgiyi tanımla
  CountDownStr:=CountDown_Edt.Text;

  // Kutuya yaz
  CountDown_Edt.Text:=CountDownStr;
end;

procedure TForm1.CheckIdleBox;
var
  IdleStr: ShortString;
begin
  // Boş eskiye döndür
  if (Idle_Edt.Text='') then
  begin
    Idle_Edt.Text:=PrevIdle;
  end;

  // Yanlış ise eskiye döndür

  // Şu anki sayıyı hafızada tut
  PrevIdle:=Idle_Edt.Text;

  // Dizgiyi tanımla
  IdleStr:=Idle_Edt.Text;

  // Kutuya yaz
  Idle_Edt.Text:=IdleStr;
end;

function TForm1.AddLeadingZero(Sender: TObject; const Value: String): String;
var
  Str: String;
  TempEdt: TEdit;
begin
  if(Sender is TEdit) then
  begin
    TempEdt:=TEdit.create(self);
    TempEdt:=TEdit(Sender);
    Str:=TempEdt.Text;
    if (Str='') then
    begin
      Str:='00';
      TempEdt.Text:=Str;
    end
    else
    begin
      Str:=FormatFloat('00', Str.ToInteger);
    end;
    TempEdt:=nil;
    TempEdt.Free;
    Result:=Str;
  end;
end;

function TForm1.RemoveLeadingZero(const Value: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(Value) do
    if Value[i]<>'0' then
    begin
      Result := Copy(Value, i, MaxInt);
      exit;
    end;
  Result := '';
end;

function TForm1.Tokenize(Str: String): String;
var
  StrTok: String;
  Num: Integer;
  Count: Integer;
begin
  StrTok:='';
  Num:=0;
  Count:=1;
  StrTok:=Str;

  while (Num <= StrTok.Length - 1) do
  begin
    if (StrTok.Substring(NPos(',', StrTok, Count) - 1, 1) = ',') And (StrTok.Substring(NPos(',', StrTok, Count) - 2, 1) <> '\') then
    begin
      StrTok:=StrTok.Insert(NPos(',', StrTok, Count) - 1, '\');
      Count:=Count + 1;
    end;
    Num:=Num + 1;
  end;
  Result:=StrTok;
end;

function TForm1.DeTokenize(Str: String; DeleteChar: Boolean): String;
var
  StrStrip: String;
begin
  StrStrip:='';
  StrStrip:=Str;

  if (Pos('\,', Str) >= 1) then
  begin
    if (DeleteChar = True) then
    begin
      StrStrip:=StringReplace(Str, '\,', '', [rfReplaceAll, rfIgnoreCase]);
    end
    else
    begin
      StrStrip:=StringReplace(Str, '\,', ',', [rfReplaceAll, rfIgnoreCase]);
    end;
  end;

  Result:=StrStrip;
end;

function TForm1.GetTok(Request: String; Count: Integer; Delimiter: Char): String;
var
  I: Integer;
  Str: String;
  StartIndex: Integer;
  EndIndex: Integer;
  Found: Boolean;
  DelimiterCount: Integer;
  Decrement: Integer;
begin
  Str:='';
  I:=0;
  Found:=False;
  DelimiterCount:=0;
  StartIndex:=0;
  EndIndex:=0;
  Decrement:=0;


  Str:=Request;
  if (Count = 1) then
  begin
    StartIndex:=0;
    Found:=True;
  end;

  // Toplam ayracı bul
  for i := 1 to Length(Str) do
  begin
    if (Str.Substring(i, 1) = Delimiter) then
    begin
      if (Str.Substring(i -1, 1) <> '\') then // Kaçış sekansı değilse
      begin
        DelimiterCount:=DelimiterCount + 1;
      end;
    end;
  end;
  if (DelimiterCount <= Count - 2) then
  begin
    WriteLn('GetTok Hatasi: Aşırı ayraç isteği:  DelimiterCount: ' + DelimiterCount.ToString + '   Count: ' + Count.ToString);
    Form1.Close;
  end;


  // Bitiş indisini bul
  for I:=0 To Str.Length do
  begin
    if (Str.Substring(I, 1) = Delimiter) then
    begin
      if (Str.Substring(I - 1, 1) = '\') then // Ayraç harici virgül var ise yoksay
      begin
        Decrement:=Decrement + 1;
      end
      else
      begin
        if (I = NPos(Delimiter, Str, Count + Decrement - 1) - 1) And (Found = False) then
        begin
          StartIndex:=I + 1;
          Found:=True;
        end;
        if (I = NPos(Delimiter, Str, Count + Decrement) - 1) And (Found = True) then // Bitiş indisini ata
        begin
          EndIndex:=I - StartIndex;
        end;
      end;
    end
    else if (I = Str.Length) And (EndIndex <= 0) then
    begin
      EndIndex:=Str.Length;
    end;
  end;
  Str:=Str.SubString(StartIndex, EndIndex);

  I:=0;
  StartIndex:=0;
  EndIndex:=0;
  Found:=False;
  DelimiterCount:=0;
  Decrement:=0;

  Result:=Str;
end;

function TForm1.SetTok(S: String; InsertS: String; Count: Integer; Delimiter: Char): String;
var
  I: Integer;
  Str: String;
  StartIndex: Integer;
  EndIndex: Integer;
  Found: Boolean;
  DelimiterCount: Integer;
  Decrement: Integer;
begin
  Str:='';
  I:=0;
  Found:=False;
  DelimiterCount:=0;
  StartIndex:=0;
  EndIndex:=0;
  Decrement:=0;


  Str:=S;
  if (Count = 1) then
  begin
    StartIndex:=0;
    Found:=True;
  end;

  // Toplam ayracı bul
  for i := 1 to Length(Str) do
  begin
    if (Str.Substring(i, 1) = Delimiter) then
    begin
      if (Str.Substring(i -1, 1) <> '\') then // Kaçış sekansı değilse
      begin
        DelimiterCount:=DelimiterCount + 1;
      end;
    end;
  end;
  if (DelimiterCount <= Count - 2) then
  begin
    WriteLn('GetTok Hatasi: Aşırı ayraç isteği:  DelimiterCount: ' + DelimiterCount.ToString + '   Count: ' + Count.ToString);
    Form1.Close;
  end;


  // Bitiş indisini bul
  for I:=0 To Str.Length do
  begin
    if (Str.Substring(I, 1) = Delimiter) then
    begin
      if (Str.Substring(I - 1, 1) = '\') then // Ayraç harici virgül var ise yoksay
      begin
        Decrement:=Decrement + 1;
      end
      else
      begin
        if (I = NPos(Delimiter, Str, Count + Decrement - 1) - 1) And (Found = False) then
        begin
          StartIndex:=I + 1;
          Found:=True;
        end;
        if (I = NPos(Delimiter, Str, Count + Decrement) - 1) And (Found = True) then // Bitiş indisini ata
        begin
          EndIndex:=I - StartIndex;
        end;
      end;
    end
    else if (I = Str.Length) And (EndIndex <= 0) then
    begin
      EndIndex:=Str.Length - 1;
    end;
  end;
  Str:=Str.Remove(StartIndex, EndIndex);
  Str:=Str.Insert(StartIndex, InsertS);

  I:=0;
  StartIndex:=0;
  EndIndex:=0;
  Found:=False;
  DelimiterCount:=0;
  Decrement:=0;

  Result:=Str;
end;

function TForm1.TokLen(S: String; D: Char): Byte;
var
  Str: String;
  Num: Integer;
  Delimiter: ShortString;
  Count: Integer;
begin
  Str:='';
  Delimiter:='';
  Num:=0;
  Count:=0;

  Str:=S;
  Delimiter:=D;

  while (Num <= Str.Length - 2) do
  begin
    if (Str.Substring(Num, 1) = Delimiter) then
    begin
      Count:=Count + 1;
    end;
    Num:=Num + 1;
  end;
  Count:=Count + 1; // Ayraç toplamına bir ekle

  Str:='';
  Num:=0;
  Delimiter:='';

  Result:=Count;
end;

end.

