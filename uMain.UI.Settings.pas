unit uMain.UI.Settings;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Forms, IniFiles;

procedure UI_LoadSettings(AForm: TObject);
procedure UI_SaveSettings(AForm: TObject);

implementation

uses
  uMain, uMain.UI.Menu;

procedure UI_LoadSettings(AForm: TObject);
var
  F: TfrmMain;
  xIni: TMemIniFile;
  xIniFileName: string;
  FirstRun: Boolean;
  FormLeft, FormTop: Integer;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  xIniFileName := ChangeFileExt(Application.ExeName, '.ini');
  xIni := TMemIniFile.Create(xIniFileName, TEncoding.UTF8);
  FirstRun := not FileExists(xIniFileName);
  try
    if FirstRun then
      F.Position := poDesktopCenter
    else
    begin
      FormLeft := xIni.ReadInteger('Form', 'Left', F.Left);
      FormTop := xIni.ReadInteger('Form', 'Top', F.Top);
      F.FAlwaysOnTop := xIni.ReadBool('Form', 'AlwaysOnTop', False);
      F.Position := poDesigned;
      F.SetBounds(FormLeft, FormTop, F.Width, F.Height);
    end;

    UI_AlwaysOnTop(F, False);

    F.chkDigits.Checked := xIni.ReadBool('Main', 'Digits', F.chkDigits.Checked);
    F.chkLowerCase.Checked := xIni.ReadBool('Main', 'LowerCase', F.chkLowerCase.Checked);
    F.chkUpperCase.Checked := xIni.ReadBool('Main', 'UpperCase',  F.chkUpperCase.Checked);
    F.chkSpecialChars.Checked := xIni.ReadBool('Main', 'SpecialChars', F.chkSpecialChars.Checked);

    F.edtLength.Value := xIni.ReadInteger('Main', 'Length', F.edtLength.Value);

    F.edtPrefix.Text := xIni.ReadString('Main', 'Prefix', F.edtPrefix.Text);
    F.edtSuffix.Text := xIni.ReadString('Main', 'Suffix', F.edtSuffix.Text);

    if not (F.chkDigits.Checked or F.chkLowerCase.Checked or
        F.chkUpperCase.Checked or F.chkSpecialChars.Checked) then
    begin
      F.chkLowerCase.Checked := True;
    end;

  finally
    xIni.Free;
  end;
end;

procedure UI_SaveSettings(AForm: TObject);
var
  F: TfrmMain;
  xIni: TMemIniFile;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  xIni := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    xIni.WriteInteger('Form', 'Left', F.Left);
    xIni.WriteInteger('Form', 'Top', F.Top);
    xIni.WriteBool('Form', 'AlwaysOnTop', F.FAlwaysOnTop);

    xIni.WriteBool('Main', 'Digits', F.chkDigits.Checked);
    xIni.WriteBool('Main', 'LowerCase', F.chkLowerCase.Checked);
    xIni.WriteBool('Main', 'UpperCase', F.chkUpperCase.Checked);
    xIni.WriteBool('Main', 'SpecialChars', F.chkSpecialChars.Checked);

    xIni.WriteInteger('Main', 'Length', F.edtLength.Value);

    if F.edtPrefix.Text = '' then
      xIni.DeleteKey('Main', 'Prefix')
    else
      xIni.WriteString('Main', 'Prefix', F.edtPrefix.Text);

    if F.edtSuffix.Text = '' then
      xIni.DeleteKey('Main', 'Suffix')
    else
      xIni.WriteString('Main', 'Suffix', F.edtSuffix.Text);

    xIni.UpdateFile;
  finally
    xIni.Free;
  end;
end;

end.
