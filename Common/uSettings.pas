unit uSettings;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Forms, IniFiles;

procedure UI_LoadFormSettings(AForm: TForm);
procedure UI_SaveFormSettings(AForm: TForm);

implementation

procedure UI_LoadFormSettings(AForm: TForm);
var
  Ini: TMemIniFile;
  IniFileName: string;
  FirstRun: Boolean;
  FormLeft, FormTop, FormWidth, FormHeight: Integer;
begin
  if AForm = nil then Exit;

  IniFileName := ChangeFileExt(Application.ExeName, '.ini');
  Ini := TMemIniFile.Create(IniFileName, TEncoding.UTF8);
  try
    FirstRun := not FileExists(IniFileName);
    if FirstRun then
      AForm.Position := poDesktopCenter
    else
    begin
      FormLeft := Ini.ReadInteger('Form', 'Left', AForm.Left);
      FormTop := Ini.ReadInteger('Form', 'Top', AForm.Top);
      FormWidth := Ini.ReadInteger('Form', 'Width', AForm.Width);
      FormHeight := Ini.ReadInteger('Form', 'Height', AForm.Height);

      var StateInt := Ini.ReadInteger('Form', 'WindowState', Ord(wsNormal));

      if StateInt = Ord(wsMinimized) then
        StateInt := Ord(wsNormal);

      if (FormLeft >= Screen.Width)
        or (FormTop  >= Screen.Height)
        or (FormLeft + FormWidth  <= 0)
        or (FormTop + FormHeight <= 0) then
      begin
        AForm.Position := poDesktopCenter;
        AForm.WindowState := wsNormal;
      end
      else
      begin
        AForm.Position := poDesigned;
        AForm.SetBounds(FormLeft, FormTop, FormWidth, FormHeight);
        AForm.WindowState := TWindowState(StateInt);
      end;
    end;
  finally
    Ini.Free;
  end;
end;

procedure UI_SaveFormSettings(AForm: TForm);
var
  Ini: TMemIniFile;
  WindowState: TWindowState;
begin
  if AForm = nil then Exit;

  Ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'), TEncoding.UTF8);
  try
    WindowState := AForm.WindowState;
    Ini.WriteInteger('Form', 'WindowState', Ord(WindowState));

    if WindowState = wsNormal then
    begin
      Ini.WriteInteger('Form', 'Left', AForm.Left);
      Ini.WriteInteger('Form', 'Top', AForm.Top);
      Ini.WriteInteger('Form', 'Width', AForm.Width);
      Ini.WriteInteger('Form', 'Height', AForm.Height);
    end;

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
