unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Forms, Clipbrd,
  uMain, uPassword;

procedure AppController_Generate(AForm: TfrmMain);
procedure AppController_Copy(AForm: TfrmMain);
procedure AppController_Exit(AForm: TfrmMain);

implementation

uses
  uMessageBox,
  uAppMenu, uAppStrings;

procedure AppController_Generate(AForm: TfrmMain);
var
  Opt: TPasswordOptions;
  Pwd, ErrMsg: string;
begin
  if AForm = nil then Exit;

  Opt.Len := AForm.edtLength.Value;
  Opt.Groups := [];
  if AForm.chkDigits.Checked then Include(Opt.Groups, pcgDigits);
  if AForm.chkLowerCase.Checked then Include(Opt.Groups, pcgLowercase);
  if AForm.chkUpperCase.Checked then Include(Opt.Groups, pcgUppercase);
  if AForm.chkSpecialChars.Checked then Include(Opt.Groups, pcgSpecialChars);

  Opt.RequireAllGroups := True;
  Opt.SpecialCharSet := '';

  if GeneratePassword(Opt, Pwd, ErrMsg) then
  begin
    AForm.mmoResult.Text := AForm.edtPrefix.Text + Pwd + AForm.edtSuffix.Text;
    AppMenu_Update(AForm);
  end
  else
    UI_MessageBox(AForm, ErrMsg, MB_ICONWARNING or MB_OK);
end;

procedure AppController_Copy(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  if AForm.mmoResult.Text <> '' then
  begin
    try
      Clipboard.AsText := AForm.mmoResult.Text;
    except
      on E: Exception do
        UI_MessageBox(AForm, Format(SClipboardCopyErrMsg, [E.Message]), MB_ICONERROR or MB_OK);
    end;
  end;
end;

procedure AppController_Exit(AForm: TfrmMain);
begin
  if AForm = nil then Exit;
  AForm.Close;
end;

end.
