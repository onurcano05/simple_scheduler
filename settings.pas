unit settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Menus, LCLIntf, Dos,
  dom, xmlread, XMLWrite, XMLUtils,
  countdown_dialog, Lng, Config;

type

  { TSettings_Frm }

  TSettings_Frm = class(TForm)
    Close_Btn: TButton;
    CheckForUpdates_Chbx: TCheckBox;
    RestartOfProgramRequired_Lbl: TLabel;
    Language_Cmbx: TComboBox;
    Language_Lbl: TLabel;
    RememberInputs_Chbx: TCheckBox;
    Control_Pctrl: TPageControl;
    Desc_Lbl: TLabel;
    Donate_Lbl: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    Settings_Tsh: TTabSheet;
    About_Tsh: TTabSheet;
    TimeOutSecs_Lbl: TLabel;
    TimeOut_Edt: TEdit;
    TimeOut_Lbl: TLabel;
    About_Lbl: TLabel;
    Warn_Chbx: TCheckBox;
    procedure CheckForUpdates_ChbxChange(Sender: TObject);
    procedure Close_BtnClick(Sender: TObject);
    procedure Donate_LblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RememberInputs_ChbxChange(Sender: TObject);
    procedure TimeOut_EdtEditingDone(Sender: TObject);
    procedure Warn_ChbxChange(Sender: TObject);

  private
    SettingsPath: String;
    FCheckForUpdates: Boolean;
    FRememberInputs: Boolean;
    FWarnBeforeAction: Boolean;
    FTimeOut: ShortString;
    FVerStr: ShortString;
    LanguageUnit: TLanguageUnit1;
    FDefaultLanguage: ShortString;
    FCurrentLanguage: ShortString;

  public
    property DefaultLanguage: ShortString read FDefaultLanguage write FDefaultLanguage;
    property CurrentLanguage: ShortString read FCurrentLanguage write FCurrentLanguage;
    property CheckForUpdates: Boolean read FCheckForUpdates write FCheckForUpdates;
    property RememberInputs:Boolean read FRememberInputs write FRememberInputs;
    property WarnBeforeAction: Boolean read FWarnBeforeAction write FWarnBeforeAction;
    property TimeOut: ShortString read FTimeOut write FTimeOut;
    property VerStr: ShortString read FVerStr write FVerStr;

  end;

var
  Settings_Frm: TSettings_Frm;


implementation

{$R *.lfm}

{ TSettings_Frm }

procedure TSettings_Frm.FormCreate(Sender: TObject);
begin
  SettingsPath:=GetEnv('APPDATA') + '\Simple Scheduler\settings.txt';
end;

procedure TSettings_Frm.FormShow(Sender: TObject);
var
  Config: PConfig;
begin
  New(Config);
  Config^:=TConfig.Create(nil, settingsPath, '=');

  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=Config^.ReadTextFile('language');
  LanguageUnit.SetText;

  // Dili uygula
  Settings_Frm.Caption:=LanguageUnit.SettingsFrmCaption;
  Settings_Tsh.Caption:=LanguageUnit.SettingsTshCaption;
  About_Tsh.Caption:=LanguageUnit.AboutTshCaption;
  Language_Lbl.Caption:=LanguageUnit.LanguageLblCaption;
  CheckForUpdates_Chbx.Caption:=LanguageUnit.CheckForUpdatesChbxCaption;
  RememberInputs_Chbx.Caption:=LanguageUnit.RememberInputsChbxCaption;
  Warn_Chbx.Caption:=LanguageUnit.WarnBeforeActionChbxCaption;
  TimeOut_Lbl.Caption:=LanguageUnit.TimeOutLblCaption;
  TimeOut_Lbl.Caption:=LanguageUnit.TimeOutLblCaption;
  TimeOutSecs_Lbl.Caption:=LanguageUnit.TimeOutSecsLblCaption;
  Close_Btn.Caption:=LanguageUnit.CloseBtnCaption;
  Donate_Lbl.Caption:=LanguageUnit.DonateLblCaption;
  RestartOfProgramRequired_Lbl.Caption:=LanguageUnit.RestartOfProgramRequiredLblCaption;

  {AboutStr:=LanguageUnit.AboutLblCaption + ' cangunay@yandex.com';
  AboutStr:=AboutStr.Replace('%ver%', FVerStr);
  About_Lbl.Caption:=AboutStr;}

  // Kontrol özellikleri
  Language_Cmbx.ItemIndex:=Language_Cmbx.Items.IndexOf(DefaultLanguage);
  Control_Pctrl.ActivePage:=Settings_Tsh; // Ayarlar sekmesini etkin yap

  CheckForUpdates_Chbx.Checked:=FCheckForUpdates;
  RememberInputs_Chbx.Checked:=FRememberInputs;
  Warn_Chbx.Checked:=FWarnBeforeAction;
  TimeOut_Edt.Text:=FTimeOut;

  // Zaman aşımı kutusunu sadece gerektiğinde etkinleştir
  TimeOut_Lbl.Enabled:=FWarnBeforeAction;
  TimeOut_Edt.Enabled:=FWarnBeforeAction;
  TimeOutSecs_Lbl.Enabled:=FWarnBeforeAction;

  // Yeniden başlatma uyarısını sadece gerektiğinde göster
  if (CurrentLanguage = DefaultLanguage) then
    RestartOfProgramRequired_Lbl.Visible:=False
  else
    RestartOfProgramRequired_Lbl.Visible:=True;
end;

procedure TSettings_Frm.RememberInputs_ChbxChange(Sender: TObject);
var
  IsChecked: Boolean;
begin
  IsChecked:=RememberInputs_Chbx.Checked;
  if (IsChecked=True) then
  begin
    FRememberInputs:=True;
  end
  else
  begin
    FRememberInputs:=False;
  end;
end;

procedure TSettings_Frm.TimeOut_EdtEditingDone(Sender: TObject);
begin
  FTimeOut:=TimeOut_Edt.Text;
end;

procedure TSettings_Frm.Warn_ChbxChange(Sender: TObject);
var
  IsChecked: Boolean;
begin
  IsChecked:=Warn_Chbx.Checked;
  if (IsChecked=True) then // İşaretli ise
  begin
    FWarnBeforeAction:=True;
  end
  else
  begin // İşaretliyse değilse
    FWarnBeforeAction:=False;
  end;

  TimeOut_Lbl.Enabled:=FWarnBeforeAction;
  TimeOut_Edt.Enabled:=FWarnBeforeAction;
  TimeOutSecs_Lbl.Enabled:=FWarnBeforeAction;
end;

procedure TSettings_Frm.Donate_LblClick(Sender: TObject);
begin
  if (FCurrentLanguage = 'english') then
  begin
    OpenUrl('https://rock55.neocities.org/eng/donate.html');
  end
  else if (FCurrentLanguage = 'turkish') then
  begin
    OpenUrl('https://rock55.neocities.org/bagis.html');
  end;
end;

procedure TSettings_Frm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  Config: PConfig;
begin
  LanguageUnit:=TLanguageUnit1.Create;
  LanguageUnit.DefaultLanguage:=DefaultLanguage;
  LanguageUnit.SetText;

  New(Config);
  Config^:=TConfig.Create(nil, settingsPath, '=');

  // Varsayılan dili uygulamanad kaydet
  Config^.WriteTextFile(settingsPath, 'language', FDefaultLanguage);

  // Güncelleme isteniyor mu
  Config^.WriteTextFile(SettingsPath, 'updates', FCheckForUpdates.ToString);

  // Kutu içerikleri saklansın mı
  Config^.WriteTextFile(settingsPath, 'rememberInputs', FRememberInputs.ToString);

  // Uyarma isteniyor mu
  Config^.WriteTextFile(settingsPath, 'warn', FWarnBeforeAction.ToString);

  // Zaman aşımı süresi
  Config^.WriteTextFile(settingsPath, 'warnTimeOut', FTimeOut);

  // Varsayılan dili kaydet
  if (DefaultLanguage <> Language_Cmbx.Text) then
  begin
    ShowMessage(LanguageUnit.RestartOfProgramRequiredMsg);
  end;
  Config^.WriteTextFile(settingsPath, 'language', Language_Cmbx.Text);

  // Zaman aşımı süresi
  FTimeOut:=TimeOut_Edt.Text;
  if (FTimeOut='') then
  begin
    FTimeOut:='30';
  end;
  TimeOut:=FTimeOut;
  countdown_dialog.CountDownDialog_Frm.TimeOut:=FTimeOut;
  TimeOut_Edt.Text:=FTimeOut;
  Config^.WriteTextFile(settingsPath, 'warnTimeOut', TimeOut_Edt.Text);

  Config^.Destroy;
  Config:=nil;
  Dispose(Config);
end;

procedure TSettings_Frm.CheckForUpdates_ChbxChange(Sender: TObject);
var
  IsChecked: Boolean;
begin
  IsChecked:=CheckForUpdates_Chbx.Checked;
  if (IsChecked=True) then
  begin
    FCheckForUpdates:=True;
  end
  else
  begin
    FCheckForUpdates:=False;
  end;
end;

procedure TSettings_Frm.Close_BtnClick(Sender: TObject);
begin
  LanguageUnit.Free;
  Close;
end;

end.

