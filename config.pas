unit Config;

{$mode objfpc}
{$m+}
{$TYPEDADDRESS ON}

interface

uses
  Classes, SysUtils, StrUtils,
  token;

type
  {TConfig}
  PConfig = ^TConfig;
  TConfig = class
  private
    FConfigFile: String;
    FDelimiter: Char;
    FListOfConfig: TStringList;
    // ListOfDebug: TStringList;
    function TrimLeadingZeros(const S: String): String;
  protected
    procedure DoRun;
  public
    constructor Create(TheOwner: TComponent; Cf: String; Dl: Char);
    destructor Destroy;
    function ReadTextFile(Req: ShortString): String;
    procedure WriteTextFile(InputFile: String; Text: String; RightText: String);
    procedure WriteApply;
    property ListOfConfig: TStringList read FListOfConfig;
  end;

implementation

function TConfig.ReadTextFile(Req: ShortString): String;
var
  Str           : String;
  StrPtr        : ^String;
  I             : Integer;
  IntPtr        : PInteger;
  Request       : ShortString;
  RequestPtr    : PShortString;

  ListOfImport  : TStringList;
  Token         : PToken;
begin
  Str:='';
  StrPtr:=nil;
  StrPtr:=@Str;

  I:=0;
  IntPtr:=nil;
  IntPtr:=@I;

  Request:='';
  RequestPtr:=nil;
  RequestPtr:=@Req;

  New(Token);
  Token^:=TToken.Create(nil);

  ListOfImport:=TStringList.Create;
  if (FileExists(FConfigFile)) then
  begin
    try
      ListOfImport.LoadFromFile(FConfigFile, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        raise Exception.Create('Playlistprogram error - File not found. Cannot access file: ' + FConfigFile + E.Message);
        Halt(-1);
      end;
    end;
  end
  else
  begin
    WriteLn('Playlistprogram error - File not found. Cannot access file: ' + FConfigFile);
    Halt(-1);
  end;

  for I:=0 to ListOfImport.Count - 1 do
  begin
    StrPtr^:=ListOfImport[IntPtr^];
    if (StrPtr^ <> '') and (Copy(StrPtr^, 0, 1) <> ';') then
    begin
      if (Token^.GetTok(StrPtr^, 1, '=') = RequestPtr^) then
      begin
        StrPtr^:=Token^.GetTok(StrPtr^, 2, '=');
        Result:=StrPtr^;
        Break;
      end;
    end;
  end;

  ListOfImport:=nil;
  ListOfImport.Free;

  StrPtr:=nil;
  IntPtr:=nil;
  RequestPtr:=nil;

  Dispose(Token);
end;

procedure TConfig.WriteTextFile(InputFile: String; Text: String; RightText: String);
var
  I: Integer;
  Str: ^String;

  Token: PToken;
begin
  I:=0;
  New(Str);
  Str^:='';
  New(Token);
  Token^:=TToken.Create(nil);

  FListOfConfig.Sorted:=False;
  FListOfConfig.LoadFromFile(InputFile, TEncoding.UTF8);
  {ListOfDebug:=TStringList.Create;
  ListOfDebug.Sorted:=False;

  ListOfDebug.LoadFromFile('debug.txt', TEncoding.UTF8);}

  for I:=0 to FListOfConfig.Count - 1 do
  begin
    Str^:=Token^.GetTok(FListOfConfig[I], 1, '=');

    if (Str^ = Text) then
    begin
      FListOfConfig[I]:=Token^.SetTok(FListOfConfig[I], RightText, 2, '=');
    end;
  end;

  FListOfConfig.SaveToFile(FConfigFile, TEncoding.UTF8);
  // ListOfDebug.SaveToFile('debug.txt', TEncoding.UTF8);

  Token^.Destroy;
  Token:=nil;
  Dispose(Token);
end;

procedure TConfig.WriteApply;
begin
  FListOfConfig.SaveToFile(FConfigFile, TEncoding.UTF8);
end;

function TConfig.TrimLeadingZeros(const S: String): String;
var
  I, L: Integer;
begin
  L:= Length(S);
  I:= 1;
  while (I < L) and (S[I] = '0') do Inc(I);

  if (StrToInt(Copy(S, I, Length(S))) <= 0) or (Copy(S, I, Length(S)) = '') then Result:='0'
  else Result:=Copy(S, I, Length(S));
end;

procedure TConfig.DoRun;
begin

end;

constructor TConfig.Create(TheOwner: TComponent; Cf: String; Dl: Char);
begin
  inherited Create;

  FConfigFile:=Cf;
  FDelimiter:=Dl;

  FListOfConfig:=TStringList.Create;
  FListOfConfig.Sorted:=False;

  DoRun;
end;

destructor TConfig.Destroy;
begin
  inherited Destroy;

  // ListOfDebug:=nil;
  // ListOfDebug.Free;
  FListOfConfig:=nil;
  FListOfConfig.Free;
end;

begin

end.

