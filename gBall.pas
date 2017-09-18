unit gBall;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Math;

type
  Moving = record
    Direction: Boolean;
    Velocity: Integer;
  end;

  Tower = record
    Height: Integer;
    Sector: Boolean;
    Arr: Array [0 .. 20, 0 .. 250] of Integer;
  end;

  Score = record
    currentScore: Integer;
    highScore: Integer;

  end;

  Ball = record
    prev: TRect;
    prevLoc: TPoint;
    curr: TRect;
    currLoc: TPoint;
  end;

  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox2: TCheckBox;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    function colorF(im: TImage; cl: TColor; p: TPoint): Integer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
    function Shift(a, b: TImage): Integer;
    function addNewLine(a: TImage): Integer;
    procedure loadFArray();
    function moveX(p: TPoint; c: Moving; f: Integer): Integer;
    function circ(im: TImage; p: TPoint; r: Integer): Integer;
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Image1MouseLeave(Sender: TObject);
    procedure Image1MouseEnter(Sender: TObject);
    function Ended(img: TImage; p: TPoint): Boolean;
    function absVal(i: Integer): Integer;
    procedure Button2Click(Sender: TObject);
    procedure initializeTower;
    procedure Button3Click(Sender: TObject);
    procedure incScore;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure drawBall;
    procedure rmBall;
    procedure updateDevLabels;
    procedure Image1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FArray: Array of TColor;

  pPos: TPoint;
  nowX: Moving;
  started, canResume: Boolean;
  factor: Integer;
  towX: Tower;
  towerCounter: Integer;
  tDelay: Integer;
  prevTowDir: Boolean;
  reset: Boolean;
  cols: Array [0 .. 7] of TColor;
  points: Score;
  towCol: TColor;
  bDrawn: Boolean;
  tball: Ball;
  gVal: Integer;
  mousec: Boolean;

const
  Up = True;
  Down = False;
  bgCol = clBlack;
  safeCol = clWhite;
  keyCol = clRed;

implementation

{$R *.dfm}

function TForm1.absVal(i: Integer): Integer;
begin

  result := Round(Power(Power(i, 2), 0.5))
end;

function TForm1.addNewLine(a: TImage): Integer;
var
  i: Integer;
begin
  for i := 0 to a.Height do
    Image1.Canvas.Pixels[Image1.Width - 1, i] := FArray[i];

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if canResume then
  begin
    with Button1 do
    begin
      if Caption = 'Pause Game' then
        Caption := 'Start Game'
      else
        Caption := 'Pause Game';
    end;

  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  canResume := False;
  started := False;
  points.currentScore := -1;
  incScore;

  FormCreate(Sender);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage
    ('Help the ball cross the hurdles by switching gravity with your mouse; move the mouse above/below the red line to switch gravity up or down. Keep it away from the edges; Move the mouse out of the frame to puase the game.');
end;

function TForm1.circ(im: TImage; p: TPoint; r: Integer): Integer;
begin
  with im.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := safeCol;
    Pen.Style := psSolid;
    Pen.Color := safeCol;

    Ellipse(p.X - r, p.Y + r, p.X + r, p.Y - r);
    Brush.Color := keyCol;
    Pen.Color := keyCol;

  end;

end;

function TForm1.colorF(im: TImage; cl: TColor; p: TPoint): Integer;
var
  i: Integer;
  j: Integer;
begin
  p.X := p.X - 1;
  with im.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := cl;
    FillRect(Rect(Point(0, 0), Point(im.Width, im.Height)));
    Pixels[p.X, p.Y] := keyCol;
    // ppos := shiftPos() ;

  end;

end;

procedure TForm1.drawBall;

begin
  //
end;

function TForm1.Ended(img: TImage; p: TPoint): Boolean;
begin
  if ((p.Y > img.Height) OR (p.Y < 0) OR NOT(canResume)) then
    result := True;

end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Screen.Cursor := crDefault;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin

  Image1.Height := 600;
  Image1.Width := 600;
  // using image1.height or width instead of 600 so I can change the dimensions easily;
  Form1.Width := Image1.Width + 400;
  Form1.Height := Image1.Width + 200;

  // Screen.Cursor := crNone;
  Image1.Canvas.Pixels[Image1.Width div 2, Image1.Height div 2] := keyCol;
  pPos := Point(Image1.Width div 2, Image1.Height div 2);
  colorF(Image1, bgCol, pPos);
  // Edit1.Visible := False;
  started := False;
  SetLength(FArray, Image1.Height);
  nowX.Direction := Down;
  nowX.Velocity := 0;
  canResume := True;
  for i := 0 to Image1.Width do
    Image1.Canvas.Pixels[i, Image1.Height Div 2] := safeCol;
  tDelay := 100;
  Button1.Enabled := True;
  // pre
  cols[0] := clBlue;
  cols[1] := clAqua;
  cols[2] := clGray;
  cols[3] := clBlack;
  cols[4] := clYellow;
  cols[5] := $FFA500;
  cols[6] := $FFD700;
  cols[7] := $FF00FF;
  Button1.Caption := 'Start Game';

  towCol := clGreen;
  bDrawn := False;
  with tball do
  begin
    prev := Rect(0, 0, 0, 0);
    prevLoc := Point(0, 0);
    curr := Rect(0, 0, 0, 0);
    currLoc := Point(0, 0);
  end;
  gVal := 1;

  Label5.Visible := False;
   //ShowMessage('Click the frame to pause / play');
  mousec := False;

  if RadioButton1.Checked then
  RadioButton1Click(Sender);
  if RadioButton2.Checked then
  RadioButton2Click(Sender);
  if RadioButton3.Checked then
  RadioButton3Click(Sender);

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  // Button1Click(Sender);
  started := NOT(started);
  if NOT(started and canResume) then
    Button1Click(Sender);
  if NOT(Ended(Image1, pPos)) then
    Label5.Visible := Not(started);

  nowX.Velocity := 0;
end;

procedure TForm1.Image1MouseEnter(Sender: TObject);
begin

  begin

    // showmessage('Click To Start')
  end;

end;

procedure TForm1.Image1MouseLeave(Sender: TObject);
begin
if canResume then
begin
 if started then
  started := false;
  Button1Click(Sender);
  if NOT(Ended(Image1, pPos)) then

    Label5.Visible := True;
end;


end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Y > (Image1.Height div 2) then
    nowX.Direction := Up;
  if Y <= (Image1.Width div 2) then
    nowX.Direction := Down;
  factor := absVal(Y - Image1.Height);
  // Label1.Caption := IntToStr(Y);
end;

procedure TForm1.incScore;
begin
  points.currentScore := points.currentScore + 1;
  if points.currentScore > points.highScore then
    points.highScore := points.currentScore;
  Label2.Caption := IntToStr(points.currentScore);
  Label4.Caption := IntToStr(points.highScore);

end;

procedure TForm1.initializeTower;
begin
  towerCounter := 20;
  towX.Height := Random(200) + 250;
  if ((Random(1000) mod 2) = 1) then
    towX.Sector := Up
  else
    towX.Sector := Down;

end;

procedure TForm1.loadFArray;
var
  i: Integer;
begin
  for i := 0 to Length(FArray) do
    FArray[i] := bgCol;
  if towerCounter >= 0 then
  begin
    if towX.Sector = Up then
      for i := 0 to towX.Height do
        FArray[i] := towCol

    else
      for i := Image1.Height - towX.Height to Image1.Height do
        FArray[i] := towCol;
    towerCounter := towerCounter - 1;

  end
  else
  begin
    if tDelay = 0 then
    begin

      initializeTower;
      if Random(3) < 1 then
        tDelay := 100
      else
        tDelay := 200;
    end
    else
      tDelay := tDelay - 1;
  end;

  FArray[Image1.Height div 2] := safeCol;
end;

function TForm1.moveX(p: TPoint; c: Moving; f: Integer): Integer;
var
  g: Int8;
  p2: TPoint;
  s: String;
  v: Extended80;
  i: Integer;
begin
  g := gVal; // *factor;
  if nowX.Direction = Down then
    g := g * -1;

  nowX.Velocity := nowX.Velocity + g;
  p2 := p;
  Image1.Canvas.PenPos := p2;
  Image1.Canvas.Pen.Color := keyCol;

  pPos.Y := pPos.Y + nowX.Velocity;
  Image1.Canvas.LineTo(pPos.X, pPos.Y);
  if (Image1.Canvas.Pixels[pPos.X, pPos.Y] = towCol) then
    canResume := False;

  if (

    ((

    (Image1.Canvas.Pixels[pPos.X, 0] = bgCol) AND

    (Image1.Canvas.Pixels[pPos.X - 1, 0] = towCol)

    )

    OR

    ((Image1.Canvas.Pixels[pPos.X, Image1.Height - 1] = bgCol) AND
    (Image1.Canvas.Pixels[pPos.X - 1, Image1.Height - 1] = towCol)

    )

    )


    // AND

    // NOT(Ended(Image1, pPos)

    // )

    ) then
    incScore;

end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  if CheckBox2.Checked then
  begin
    Timer1.Interval := 10;
    gVal := 1;
  end
  else
    gVal := 5;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin

  if CheckBox2.Checked then
  begin
    Timer1.Interval := 25;;
    gVal := 1;
  end
  else

    gVal := 2;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin

  Timer1.Interval := 50;
  gVal := 1;
end;

procedure TForm1.rmBall;
begin
  //
end;

function TForm1.Shift(a, b: TImage): Integer;
var
  ar, br: TRect;
begin
  ar := Rect(Point(1, 0), Point(a.Width, a.Height));
  br := Rect(Point(0, 0), Point(a.Width - 1, a.Height));
  b.Canvas.CopyRect(br, b.Canvas, ar);

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (started and canResume) then

  begin
    Shift(Image1, Image1);
    loadFArray;

    moveX(pPos, nowX, factor);
    if bDrawn then
      rmBall;
    drawBall;

    if Ended(Image1, pPos) then
    begin
      canResume := False;
      ShowMessage('Game Ended');
      points.currentScore := 0;

    end;
    Image1.Canvas.Pixels[pPos.X, pPos.Y] := keyCol;

    addNewLine(Image1);
    updateDevLabels;
  end;
  if canResume = False then
    Button1.Enabled := False;

end;

procedure TForm1.updateDevLabels;
begin
  if CheckBox1.Checked then
  begin
    Label6.Caption := 'Ball Coordinates' + char(9) + IntToStr(pPos.X) + char(9)
      + ',' + IntToStr(pPos.Y);
    Label7.Caption := 'Velocity' + char(9) + IntToStr(nowX.Velocity);
  end;
end;

end.
