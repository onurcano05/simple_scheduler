unit GenerateVersionFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DOM, XMLWrite, DOS;

type
  {GenerateXML}
  TGenerateXML = class

  private
    FVersionStr: ShortString;
    FUrl: String;
    FAlternativeUrl: String;
    FFileVersion: ShortString;
    FDatePublished: ShortString;

  public
    property VersionStr: ShortString read FVersionStr write FVersionStr;
    property Url: String read FUrl write FUrl;
    property AlternativeUrl: String read FAlternativeUrl write FAlternativeUrl;
    property FileVersion: ShortString read FFileVersion write FFileVersion;
    property DatePublished: ShortString read FDatePublished write FDatePublished;
    procedure CreateFile;
  end;

implementation

procedure TGenerateXML.CreateFile;
var
  Doc: TXMLDocument;
  RootNode, ParentNode, Son: TDomNode;
begin
  try
    Doc:=TXMLDocument.Create;

    RootNode:=Doc.CreateElement('channel');
    Doc.AppendChild(RootNode);

    ParentNode:=Doc.CreateElement('versionNum');
    Son:=Doc.CreateTextNode(FVersionStr);
    ParentNode.AppendChild(Son);
    RootNode.AppendChild(ParentNode);

    ParentNode:=Doc.CreateElement('url');
    Son:=Doc.CreateTextNode(FUrl);
    ParentNode.AppendChild(Son);
    RootNode.AppendChild(ParentNode);

    ParentNode:=Doc.CreateElement('alternativeUrl');
    Son:=Doc.CreateTextNode(FAlternativeUrl);
    ParentNode.AppendChild(Son);
    RootNode.AppendChild(ParentNode);

    ParentNode:=Doc.CreateElement('fileVersion');
    Son:=Doc.CreateTextNode(FFileVersion);
    ParentNode.AppendChild(Son);
    RootNode.AppendChild(ParentNode);

    ParentNode:=Doc.CreateElement('datePublished');
    Son:=Doc.CreateTextNode(FDatePublished);
    ParentNode.AppendChild(Son);
    RootNode.AppendChild(ParentNode);

    WriteXML(Doc, GetEnv('appdata') + '\Simple Scheduler\simple_scheduler_version.xml');
  finally
    Doc.Free;
  end;
end;

  // Gövde öğeler buraya yazılacak
end.

