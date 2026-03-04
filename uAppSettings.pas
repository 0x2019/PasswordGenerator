unit uAppSettings;

interface

uses
  System.SysUtils, Vcl.Forms, IniFiles, uMain;

procedure AppSettings_Load(AForm: TfrmMain);
procedure AppSettings_Save(AForm: TfrmMain);

implementation

procedure AppSettings_Load(AForm: TfrmMain);
var
  Ini: TMemIniFile;
begin
  if AForm = nil then Exit;

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    AForm.chkDigits.Checked := Ini.ReadBool('Main', 'Digits', True);
    AForm.chkLowerCase.Checked := Ini.ReadBool('Main', 'LowerCase', True);
    AForm.chkUpperCase.Checked := Ini.ReadBool('Main', 'UpperCase', True);
    AForm.chkSpecialChars.Checked := Ini.ReadBool('Main', 'SpecialChars', True);
    AForm.edtLength.Value := Ini.ReadInteger('Main', 'Length', 16);
    AForm.edtPrefix.Text := Ini.ReadString('Main', 'Prefix', '');
    AForm.edtSuffix.Text := Ini.ReadString('Main', 'Suffix', '');

    AForm.miAlwaysOnTop.Checked := Ini.ReadBool('Main', 'AlwaysOnTop', False);
  finally
    Ini.Free;
  end;
end;

procedure AppSettings_Save(AForm: TfrmMain);
var
  Ini: TMemIniFile;
begin
  if AForm = nil then Exit;

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    Ini.WriteBool('Main', 'AlwaysOnTop', AForm.miAlwaysOnTop.Checked);

    Ini.WriteBool('Main', 'Digits', AForm.chkDigits.Checked);
    Ini.WriteBool('Main', 'LowerCase', AForm.chkLowerCase.Checked);
    Ini.WriteBool('Main', 'UpperCase', AForm.chkUpperCase.Checked);
    Ini.WriteBool('Main', 'SpecialChars', AForm.chkSpecialChars.Checked);
    Ini.WriteInteger('Main', 'Length', AForm.edtLength.Value);
    Ini.WriteString('Main', 'Prefix', AForm.edtPrefix.Text);
    Ini.WriteString('Main', 'Suffix', AForm.edtSuffix.Text);

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
