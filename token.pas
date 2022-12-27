unit Token;

{$mode objfpc}{$H+}
{$m+}
{$TYPEDADDRESS ON}

interface

uses
  Classes, SysUtils,
  StrUtils;

type
  {TToken}
  PToken = ^TToken;
  TToken = class
  private
    function TrimLeadingZeros(const S: String): String;
  protected
    procedure DoRun;
  public
    constructor Create(TheOwner: TComponent);
    destructor Destroy;
    function Tokenize(Str: String): String;
    function DeTokenize(Str: String; DeleteChar: Boolean): String;
    function GetTok(Request: String; Count: Integer; Delimiter: Char): String;
    function SetTok(S: String; InsertS: String; Count: Integer; Delimiter: Char): String;
    function TokLen(S: String; D: Char): Byte;
  end;

implementation

{ TToken }

function TToken.TrimLeadingZeros(const S: String): String;
var
  I, L: Integer;
begin
  L:= Length(S);
  I:= 1;
  while (I < L) and (S[I] = '0') do Inc(I);
  Result:= Copy(S, I);
end;

procedure TToken.DoRun;
begin

end;

constructor TToken.Create(TheOwner: TComponent);
begin
  inherited Create;
  // StopOnException:=True;
end;

destructor TToken.Destroy;
begin
  inherited Destroy;
end;

function TToken.Tokenize(Str: String): String;
var
  StrTokPtr: ^String;
  NumPtr: ^Integer;
  CountPtr: ^Integer;
begin
  New(StrTokPtr);
  StrTokPtr^:='';
  New(NumPtr);
  NumPtr^:=0;
  New(CountPtr);
  CountPtr^:=0;

  StrTokPtr^:=Str;

  while (NumPtr^ <= StrTokPtr^.Length - 1) do
  begin
    if (StrTokPtr^ .Substring(NPos(',', StrTokPtr^, CountPtr^) - 1, 1) = ',') And (StrTokPtr^.Substring(NPos(',', StrTokPtr^, CountPtr^) - 2, 1) <> '\') then
    begin
      StrTokPtr^:=StrTokPtr^.Insert(NPos(',', StrTokPtr^, CountPtr^) - 1, '\');
      CountPtr^:=CountPtr^ + 1;
    end;
    NumPtr^:=NumPtr^ + 1;
  end;

  Dispose(NumPtr);
  Dispose(CountPtr);

  Result:=Trim(StrTokPtr^);
  Dispose(StrTokPtr);
end;

function TToken.DeTokenize(Str: String; DeleteChar: Boolean): String;
var
  StrStripPtr: ^String;
begin
  New(StrStripPtr);
  StrStripPtr^:='';

  StrStripPtr^:=Str;

  if (Pos('\,', Str) >= 1) then
  begin
    if (DeleteChar = True) then
    begin
      StrStripPtr^:=StringReplace(Str, '\,', '', [rfReplaceAll, rfIgnoreCase]);
    end
    else
    begin
      StrStripPtr^:=StringReplace(Str, '\,', ',', [rfReplaceAll, rfIgnoreCase]);
    end;
  end;

  Result:=Trim(StrStripPtr^);
  Dispose(StrStripPtr);
end;

function TToken.GetTok(Request: String; Count: Integer; Delimiter: Char
  ): String;
var
  I: Integer;
  StrPtr: ^String;
  StartIndexPtr: ^Integer;
  EndIndexPtr: ^Integer;
  Found: Boolean;
  FoundPtr: PBoolean;
  ContentCountPtr: ^Integer;
  DecrementPtr: ^Integer;
begin
  New(StrPtr);
  StrPtr^:='';

  I:=0;

  Found:=False;
  FoundPtr:=nil;
  FoundPtr:=@Found;

  New(ContentCountPtr);
  ContentCountPtr^:=0;
  New(StartIndexPtr);
  StartIndexPtr^:=0;
  New(EndIndexPtr);
  EndIndexPtr^:=0;
  New(DecrementPtr);
  DecrementPtr^:=0;

  StrPtr^:=Request;
  if (Count = 1) then
  begin
    StartIndexPtr^:=0;
    FoundPtr^:=True;
  end;

  // Toplam ayracı bul
  for i := 1 to Length(StrPtr^) do
  begin
    if (StrPtr^.Substring(i, 1) = Delimiter) then
    begin
      if (StrPtr^.Substring(i -1, 1) <> '\') then // Kaçış sekansı değilse
      begin
        ContentCountPtr^:=ContentCountPtr^ + 1;
      end;
    end;
  end;
  if (ContentCountPtr^ <= Count - 3) then // 2 rakamı 3 olarak güncellendi - 2021 / 07
  begin
    WriteLn('GetTok Error - Too much token request:  ContentCount: ' + ContentCountPtr^.ToString + '   Count: ' + Count.ToString);
    Halt(-1);
  end;


  // Bitiş indisini bul
  for I:=0 To StrPtr^.Length do
  begin
    if (StrPtr^.Substring(I, 1) = Delimiter) then
    begin
      if (StrPtr^.Substring(I - 1, 1) = '\') then // Ayraç harici virgül var ise yoksay
      begin
        DecrementPtr^:=DecrementPtr^ + 1;
      end
      else
      begin
        if (I = NPos(Delimiter, StrPtr^, Count + DecrementPtr^ - 1) - 1) And (FoundPtr^ = False) then
        begin
          StartIndexPtr^:=I + 1;
          FoundPtr^:=True;
        end;
        if (I = NPos(Delimiter, StrPtr^, Count + DecrementPtr^) - 1) And (FoundPtr^ = True) then // Bitiş indisini ata
        begin
          EndIndexPtr^:=I - StartIndexPtr^;
        end;
      end;
    end
    else if (I = StrPtr^.Length) And (EndIndexPtr^ <= 0) then
    begin
      EndIndexPtr^:=StrPtr^.Length;
    end;
  end;
  StrPtr^:=StrPtr^.SubString(StartIndexPtr^, EndIndexPtr^);

  I:=0;
  Dispose(StartIndexPtr);
  Dispose(EndIndexPtr);
  Found:=False;
  FoundPtr:=nil;
  Dispose(ContentCountPtr);
  Dispose(DecrementPtr);

  Result:=Trim(StrPtr^);
  Dispose(StrPtr);
end;

function TToken.SetTok(S: String; InsertS: String; Count: Integer;
  Delimiter: Char): String;
var
  I                 : Integer;
  StrPtr            : ^String;
  StartIndexPtr     : ^Integer;
  EndIndexPtr       : ^Integer;
  Found             : Boolean;
  FoundPtr          : PBoolean;
  DelimiterCountPtr : ^Integer;
  DecrementPtr      : ^Integer;
  CountPtr          : ^Integer;
begin
  New(StrPtr);
  StrPtr^:='';

  I:=0;

  Found:=False;
  FoundPtr:=nil;
  FoundPtr:=@Found;

  New(DelimiterCountPtr);
  DelimiterCountPtr^:=0;
  New(StartIndexPtr);
  StartIndexPtr^:=0;
  New(EndIndexPtr);
  EndIndexPtr^:=0;
  New(DecrementPtr);
  DecrementPtr^:=0;

  StrPtr^:=S;

  New(CountPtr);
  CountPtr^:=0;
  CountPtr^:=Count;

  if (CountPtr^ = 1) then
  begin
    StartIndexPtr^:=0;
    FoundPtr^:=True;
  end;

  // Toplam ayracı bul
  for i := 1 to Length(StrPtr^) do
  begin
    if (StrPtr^.Substring(i, 1) = Delimiter) then
    begin
      if (StrPtr^.Substring(i -1, 1) <> '\') then // Kaçış sekansı değilse
      begin
        DelimiterCountPtr^:=DelimiterCountPtr^ + 1;
      end;
    end;
  end;
  if (DelimiterCountPtr^ <= CountPtr^ - 2) then
  begin
    raise Exception.Create('GetTok Error: Too much token request:  DelimiterCount: ' + DelimiterCountPtr^.ToString + '   Count: ' + CountPtr^.ToString);
    Halt(-1);
  end;


  // Bitiş indisini bul
  for I:=0 To StrPtr^.Length do
  begin
    if (StrPtr^.Substring(I, 1) = Delimiter) then
    begin
      if (StrPtr^.Substring(I - 1, 1) = '\') then // Ayraç harici virgül var ise yoksay
      begin
        DecrementPtr^:=DecrementPtr^ + 1;
      end
      else
      begin
        if (I = NPos(Delimiter, StrPtr^, CountPtr^ + DecrementPtr^ - 1) - 1) And (FoundPtr^ = False) then
        begin
          StartIndexPtr^:=I + 1;
          FoundPtr^:=True;
        end;
        if (I = NPos(Delimiter, StrPtr^, CountPtr^ + DecrementPtr^) - 1) And (FoundPtr^ = True) then // Bitiş indisini ata
        begin
          EndIndexPtr^:=I - StartIndexPtr^;
        end;
      end;
    end
    else if (I = StrPtr^.Length) And (EndIndexPtr^ <= 0) then
    begin
      EndIndexPtr^:=StrPtr^.Length - 1;
    end;
  end;
  StrPtr^:=StrPtr^.Remove(StartIndexPtr^, EndIndexPtr^);
  StrPtr^:=StrPtr^.Insert(StartIndexPtr^, InsertS);

  I:=0;
  Dispose(StartIndexPtr);
  Dispose(EndIndexPtr);
  Found:=False;
  FoundPtr:=nil;
  Dispose(DelimiterCountPtr);
  Dispose(DecrementPtr);
  Dispose(CountPtr);

  Result:=Trim(StrPtr^);
  Dispose(StrPtr);
end;

function TToken.TokLen(S: String; D: Char): Byte;
var
  StrPtr: ^String;
  NumPtr: ^Integer;
  DelimiterPtr: ^ShortString;
  CountPtr: ^Integer;
begin
  New(StrPtr);
  StrPtr^:='';
  New(DelimiterPtr);
  DelimiterPtr^:='';
  New(NumPtr);
  NumPtr^:=0;

  New(CountPtr);
  CountPtr^:=0;

  StrPtr^:=S;
  DelimiterPtr^:=D;

  while (NumPtr^ <= StrPtr^.Length - 2) do
  begin
    if (StrPtr^.Substring(NumPtr^, 1) = DelimiterPtr^) then
    begin
      CountPtr^:=CountPtr^ + 1;
    end;
    NumPtr^:=NumPtr^ + 1;
  end;
  CountPtr^:=CountPtr^ + 1; // Ayraç toplamına bir ekle

  Dispose(StrPtr);
  Dispose(NumPtr);
  Dispose(DelimiterPtr);

  Result:=CountPtr^;
  Dispose(CountPtr);
end;

end.

