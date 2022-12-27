unit VersionInfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TVersion = class(TPersistent)

private
  FBuild: Integer;
  FMajor: Integer;
  FMinor: Integer;
  FVersion: Integer;

published
  property Version: Integer read FVersion write Fversion;
  property Minor: Integer read FMinor write FMinor;
  property Major: Integer read FMajor write FMajor;
  property Build: Integer read FBuild write FBuild;
end;

implementation

end.

