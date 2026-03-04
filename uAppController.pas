unit uAppController;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Forms, Clipbrd,
  uPassword;

procedure App_Generate(AForm: TObject);
procedure App_Copy(AForm: TObject);

implementation

uses
  uMain, uAppMenu, uAppStrings,
  uMessageBox;

procedure App_Generate(AForm: TObject);
var
  F: TfrmMain;
  Opt: TPasswordOptions;
  Pwd, ErrMsg: string;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  Opt.Len := F.edtLength.Value;
  Opt.Groups := [];
  if F.chkDigits.Checked then Include(Opt.Groups, pcgDigits);
  if F.chkLowerCase.Checked then Include(Opt.Groups, pcgLowercase);
  if F.chkUpperCase.Checked then Include(Opt.Groups, pcgUppercase);
  if F.chkSpecialChars.Checked then Include(Opt.Groups, pcgSpecialChars);

  Opt.RequireAllGroups := True;
  Opt.SpecialCharSet := '';

  if GeneratePassword(Opt, Pwd, ErrMsg) then
  begin
    F.mmoResult.Text := F.edtPrefix.Text + Pwd + F.edtSuffix.Text;

    AppMenu_Update(F);
  end
  else
    UI_MessageBox(F, ErrMsg, MB_ICONWARNING or MB_OK);
end;

procedure App_Copy(AForm: TObject);
var
  F: TfrmMain;
begin
  if not (AForm is TfrmMain) then Exit;
  F := TfrmMain(AForm);

  if Trim(F.mmoResult.Text) <> '' then
  begin
    try
      Clipboard.AsText := Trim(F.mmoResult.Text);
    except
      on E: Exception do
        UI_MessageBox(F, Format(SClipboardCopyErrMsg, [E.Message]), MB_ICONERROR or MB_OK);
    end;
  end;
end;

end.
