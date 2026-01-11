unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.ImageList, Vcl.Buttons,
  Vcl.Controls, Vcl.Forms, Vcl.ImgList, Vcl.Menus, sSkinProvider, sSkinManager,
  acAlphaHints, Vcl.StdCtrls, sBitBtn, sMemo, sEdit, sSpinEdit, sLabel, sCheckBox,
  sGroupBox, acAlphaImageList, Vcl.Dialogs, sDialogs, Vcl.ComCtrls, sRichEdit;

const
  mbMessage = WM_USER + 1024;

type
  TfrmMain = class(TForm)
    sAlphaHints: TsAlphaHints;
    sSkinManager: TsSkinManager;
    sSkinProvider: TsSkinProvider;
    MainMenu: TMainMenu;
    mmuFile: TMenuItem;
    mmuView: TMenuItem;
    mmuTool: TMenuItem;
    mmuHelp: TMenuItem;
    mmuAbout: TMenuItem;
    btnGenerate: TsBitBtn;
    btnCopy: TsBitBtn;
    btnExit: TsBitBtn;
    grpchar: TsGroupBox;
    chkDigits: TsCheckBox;
    chkLowerCase: TsCheckBox;
    chkUpperCase: TsCheckBox;
    chkSpecialChars: TsCheckBox;
    grpLength: TsGroupBox;
    lblLength: TsLabel;
    sGroupBox1: TsGroupBox;
    lblPrefix: TsLabel;
    edtPrefix: TsEdit;
    edtSuffix: TsEdit;
    lblSuffix: TsLabel;
    mmuClearClipboard: TMenuItem;
    mmuAlwaysOnTop: TMenuItem;
    sCharImageList: TsCharImageList;
    sCharImageList_Small: TsCharImageList;
    mmuSaveAs: TMenuItem;
    mmuExit: TMenuItem;
    sSaveDlg: TsSaveDialog;
    edtLength: TsSpinEdit;
    redResult: TsRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mmuAboutClick(Sender: TObject);
    procedure mmuClearClipboardClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure mmuAlwaysOnTopClick(Sender: TObject);
    procedure mmuSaveAsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure ChangeMessageBoxPosition(var Msg: TMessage); message mbMessage;
    procedure WMClipboardUpdate(var Msg: TMessage); message WM_CLIPBOARDUPDATE;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
  public
    FAlwaysOnTop: Boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  uMain.UI, uMain.UI.Menu, uMain.UI.Messages, uMain.UI.Settings;

procedure TfrmMain.ChangeMessageBoxPosition(var Msg: TMessage);
begin
  UI_ChangeMessageBoxPosition(Self);
end;

procedure TfrmMain.WMClipboardUpdate(var Msg: TMessage);
begin
  UI_UpdateMenu(Self);
end;

procedure TfrmMain.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  if Msg.Result = htClient then Msg.Result := htCaption;
end;

procedure TfrmMain.btnCopyClick(Sender: TObject);
begin
  UI_Copy(Self);
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  UI_Exit(Self);
end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
begin
  UI_Generate(Self);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RemoveClipboardFormatListener(Handle);
  UI_SaveSettings(Self);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  UI_Init(Self);
  AddClipboardFormatListener(Handle);
  btnGenerate.Click;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    UI_Exit(Self);
end;

procedure TfrmMain.mmuAboutClick(Sender: TObject);
begin
  UI_ShowAbout(Self);
end;

procedure TfrmMain.mmuAlwaysOnTopClick(Sender: TObject);
begin
  UI_AlwaysOnTop(Self);
end;

procedure TfrmMain.mmuClearClipboardClick(Sender: TObject);
begin
  UI_ClearClipboard(Self);
end;

procedure TfrmMain.mmuSaveAsClick(Sender: TObject);
begin
  UI_SaveAs(Self);
end;

end.
