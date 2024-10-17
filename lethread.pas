unit lethread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, FileCtrl,IntfGraphics, FPimage,
  {$IFDEF UNIX}
  //cthreads,
  //cmem,
  {$ENDIF}
  MTProcs;
type

  { TForm1 }

  TForm1 = class(TForm)
    FileListBox1: TFileListBox;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    ed1,ed2,ed3,dir,jpegquality:pchar;
    pics,pics2: array of pchar;
    n:integer;
    arrstr: array of string;

    procedure moldura_para(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.moldura_para(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);
var
  page:TBitmap;
  t:TLazIntfImage;
  cab,saver:TImage;
  style:TTextStyle;
  pic:pchar;
  cor: tfpcolor;
begin

          cab:=TImage.Create(self);
          saver:=TImage.Create(self);
          page:=TBitmap.Create;
          cab.Picture.LoadFromFile(dir+'/'+pics[Index]);
          t:=cab.Picture.Bitmap.CreateIntfImage;

          cor.red:=255;
          cor.green:=200;
          cor.blue:=155;
          t.Colors[0,0]:= cor;


          {page.Canvas.Brush.Color:=$242424;
          page.Canvas.Font.Height:=20;
          page.Canvas.Font.Color:=$F0F0F0;
          if cab.Picture.Height >= cab.Picture.Width then
          begin
            page.Height:=1560;
            page.Width:=1000;
            page.Canvas.FillRect(0,0,1000,1560);
            page.Canvas.StretchDraw(Rect(0,0,1000,1500),cab.Picture.Bitmap);
            page.Canvas.TextOut(10,1506,'Fotógrafo Criminalístico: '+ed3+'   '+
              'Registro Fotográfico nº '+ed1);
            page.Canvas.TextOut(10,1535,'Instituto Geral de Perícias - RS'
              +'    Protocolo PGP nº '+ed2);
            //if CheckBox2.Checked then
            //begin
            //  page.Canvas.TextOut(850,1510,'Foto nº '+IntToStr(Index+1));
            //end;
          end;
          if cab.Picture.Height < cab.Picture.Width then
          begin
            page.Height:=1060;
            page.Width:=1500;
            page.Canvas.FillRect(0,0,1500,1060);
            page.Canvas.StretchDraw(Rect(0,0,1500,1000),cab.Picture.Bitmap);
            page.Canvas.TextOut(10,1006,'Fotógrafo Criminalístico: '+ed3+'   '+
              'Registro Fotográfico nº '+ed1);
            page.Canvas.TextOut(10,1035,'Instituto Geral de Perícias - RS'
              +'    Protocolo PGP nº '+ed2);
            //if CheckBox2.Checked then
            //begin
            //  page.Canvas.TextOut(1350,1010,'Foto nº '+IntToStr(Index+1));
            //end;
          end;
          page.Canvas.Font.Height:=12;
          page.Canvas.Font.Color:=$505050;
          page.Canvas.TextOut(page.Width-200,page.Height-20,'dev: guilherme de moraes alvarez, 2018.');
          saver.Width:=page.Width;
          saver.Height:=page.Height;
          saver.Picture.Bitmap.Assign(page);
          saver.Picture.Jpeg.CompressionQuality:=strtoint(jpegquality);
          saver.Picture.SaveToFile(dir+'/suporte/pag'+
          FormatFloat('0000',Index)+'.jpg');         }

          page.Free;
          cab.Free;
          saver.Free;
          t.Free;
          //pics2[Index]:='OK';
          //TThread.Synchronize(CurrentThread,@update_para);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  dir:=pchar(ParamStr(1));
  ed1:=pchar(ParamStr(2));
  ed3:=pchar(ParamStr(3));
  ed2:=pchar(ParamStr(6));
  jpegquality:=pchar(ParamStr(4));
  n:=StrToInt(ParamStr(5));
  FileListBox1.Directory:=dir;
  SetLength(pics,FileListBox1.Count);
  SetLength(pics2,FileListBox1.Count);
  SetLength(arrstr,FileListBox1.Count);
  for i:=0 to FileListBox1.Count-1 do
  begin
    arrstr[i]:=FileListBox1.Items.Strings[i];
  end;
  for i:=0 to FileListBox1.Count-1 do
  begin
    pics[i]:=pchar(arrstr[i]);
    pics2[i]:='...';
  end;

  if FileListBox1.Count > 0 then
  begin
    ProcThreadPool.DoParallel(@form1.moldura_para,0,n,nil,4);
  end
  else  ShowMessage('Problema ao abrir a pasta de foto.'+FileListBox1.Directory);

  Application.Terminate;

end;

end.

