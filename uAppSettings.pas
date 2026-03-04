unit uAppSettings;

interface

uses
  System.SysUtils, Vcl.Forms, IniFiles;

procedure AppSettings_Load(AForm: TObject);
procedure AppSettings_Save(AForm: TObject);

implementation

uses
  uMain;

procedure AppSettings_Load(AForm: TObject);
var
  F: TfrmMain;
  Ini: TMemIniFile;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    F.chkDigits.Checked := Ini.ReadBool('Main', 'Digits', True);
    F.chkLowerCase.Checked := Ini.ReadBool('Main', 'LowerCase', True);
    F.chkUpperCase.Checked := Ini.ReadBool('Main', 'UpperCase', True);
    F.chkSpecialChars.Checked := Ini.ReadBool('Main', 'SpecialChars', True);
    F.edtLength.Value := Ini.ReadInteger('Main', 'Length', 16);
    F.edtPrefix.Text := Ini.ReadString('Main', 'Prefix', '');
    F.edtSuffix.Text := Ini.ReadString('Main', 'Suffix', '');

    F.miAlwaysOnTop.Checked := Ini.ReadBool('Main', 'AlwaysOnTop', False);
  finally
    Ini.Free;
  end;
end;

procedure AppSettings_Save(AForm: TObject);
var
  F: TfrmMain;
  Ini: TMemIniFile;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    Ini.WriteBool('Main', 'AlwaysOnTop', F.miAlwaysOnTop.Checked);

    Ini.WriteBool('Main', 'Digits', F.chkDigits.Checked);
    Ini.WriteBool('Main', 'LowerCase', F.chkLowerCase.Checked);
    Ini.WriteBool('Main', 'UpperCase', F.chkUpperCase.Checked);
    Ini.WriteBool('Main', 'SpecialChars', F.chkSpecialChars.Checked);
    Ini.WriteInteger('Main', 'Length', F.edtLength.Value);
    Ini.WriteString('Main', 'Prefix', F.edtPrefix.Text);
    Ini.WriteString('Main', 'Suffix', F.edtSuffix.Text);

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
