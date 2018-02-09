// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
model BatteryChargerDC "Battery charger and power converter"
	GreenBuilding.Interfaces.Electrical.DC GridDC "DC connection after dc converter to Grid" annotation(Placement(
		transformation(extent={{240,-55},{260,-35}}),
		iconTransformation(extent={{190,-110},{210,-90}})));
	GreenBuilding.Interfaces.Electrical.DC DC "DC connection to battery" annotation(Placement(
		transformation(extent={{-60,-25},{-40,-5}}),
		iconTransformation(extent={{-210,-10},{-190,10}})));
	GreenBuilding.Interfaces.Battery.BatteryBus ControlBus "Control interface for battery converter" annotation(Placement(
		transformation(extent={{-60,-120},{-40,-100}}),
		iconTransformation(extent={{-10,-210},{10,-190}})));
	constant Real Pth=1e-6 "Threshold reference power for system control" annotation(Dialog(
		group="Electrical Power",
		tab="Results"));
	input Modelica.Blocks.Interfaces.RealInput PRef(
		quantity="Basics.Power",
		displayUnit="kW") "Reference power for charge or discharge of house battery" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={0,200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	protected
		Real VICAct(
			quantity="Electricity.Voltage",
			displayUnit="V") "Actual intermediate circuit voltage" annotation(Dialog(
			group="Voltage",
			tab="Results",
			__iti_showAs=ShowAs.Result));
		Real IDCAct(
			quantity="Electricity.Current",
			displayUnit="A") "Actual intermediate circiut current" annotation(Dialog(
			group="Current",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	public
		Real PAC(
			quantity="Basics.Power",
			displayUnit="kW") "AC effective power output" annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	protected
		Real QAC(
			quantity="Basics.Power",
			displayUnit="kVA") "AC reactive power output" annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	public
		Real PDC(
			quantity="Basics.Power",
			displayUnit="kW") "DC power" annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	protected
		Boolean charged(
			start=if ControlBus.SOC.start<SOCMin then false else true,
			fixed=true) "Vehicle battery has been charged after underrun SOC minimum level" annotation(Dialog(
			group="Control",
			tab="Results",
			__iti_showAs=ShowAs.Result));
		Boolean discharged(
			start=if ControlBus.SOC.start>SOCMax then false else true,
			fixed=true) "Vehicle battery has beed discharged after overrun SOC maximun level" annotation(Dialog(
			group="Control",
			tab="Results",
			__iti_showAs=ShowAs.Result));
	public
		constant Real SOCth=0.05 "Threshold reference state of charge difference for system control" annotation(Dialog(
			group="Control",
			tab="Results"));
		parameter Real eta(
			quantity="Basics.RelMagnitude",
			displayUnit="%")=0.95 "Charge efficiency of battery charger" annotation(Dialog(
			group="Efficiency",
			tab="Parameters"));
		parameter Integer ChargePhase=1 "Number of phases of house battery charger" annotation(Dialog(
			group="Grid Connection",
			tab="Parameters"));
		parameter Real TPI(
			quantity="Basics.Time",
			displayUnit="s")=10 "Time constant of PI-controller" annotation(Dialog(
			group="Power Control",
			tab="Parameters"));
		parameter Real kPI=1 "Gain constant of PI-controller" annotation(Dialog(
			group="Power Control",
			tab="Parameters"));
		parameter Real PMax(
			quantity="Basics.Power",
			displayUnit="kW")=22000 "Maximum charge/discharge power" annotation(Dialog(
			group="Electrical Power",
			tab="Parameters"));
		parameter Real SOCMax(
			quantity="Basics.RelMagnitude",
			displayUnit="%")=0.95000000000000007 "Maximum SOC of battery for charging" annotation(Dialog(
			group="State of Charge",
			tab="Parameters"));
		parameter Real SOCMin(
			quantity="Basics.RelMagnitude",
			displayUnit="%")=0.050000000000000003 "Minimum SOC of battery for discharging" annotation(Dialog(
			group="State of Charge",
			tab="Parameters"));
		Real PDC_OUTPUT(
			quantity="Basics.Power",
			displayUnit="kW") "DC effective power output" annotation(Dialog(
			group="Power",
			tab="Results",
			__iti_showAs=ShowAs.Result));
		GreenBuilding.Utilities.Electrical.B2Converter B2Converter(eta=eta) if ChargePhase==1 "B2-Converter for 1-phase-grid-connection" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="State of Charge",
				tab="Parameters"));
		GreenBuilding.Utilities.Electrical.B2Converter B2Converter2(eta=eta) if ChargePhase==1 "B2-Converter for 1-phase-grid-connection" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="State of Charge",
				tab="Parameters"));
		GreenBuilding.Utilities.Electrical.B2CControl B2CController(
			TPI=TPI,
			kPI=kPI,
			PMax=PMax) if ChargePhase==1 "B2C-Controller for 1-phase-grid-connection" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="State of Charge",
				tab="Parameters"));
	algorithm
		when (ControlBus.SOC<SOCMax-SOCth and not pre(discharged)) then
			discharged:=true;
		elsewhen (ControlBus.SOC>SOCMax and pre(discharged)) then
			discharged:=false;
		end when;
		
		when (ControlBus.SOC>SOCMin+SOCth and not pre(charged)) then
			charged:=true;
		elsewhen (ControlBus.SOC<SOCMin and pre(charged)) then
			charged:=false;
		end when;
	equation
		B2Converter.Connected=true;
		B2Converter2.Connected=true;
		B2CController.Voc=ControlBus.Voc;
		B2CController.VIC=ControlBus.VIC;
		B2CController.VICMax=ControlBus.VICMax;
		B2CController.VICMin=ControlBus.VICMin;
		connect(B2Converter.alphaRef,B2CController.alphaRef) annotation(Line(points={{5,10},{5,15},{-5,15},{-5,-15},{0,-15},{0,
		-10}}));
		
		
		connect(B2Converter.VGrid,B2CController.VGrid) annotation(Line(points={{-5,-10},{-5,-15},{-15,-15},{-15,5},{-10,5}}));
		connect(B2Converter.IDC,B2CController.IDC) annotation(Line(points={{0,-10},{0,-15},{-15,-15},{-15,-5},{-10,-5}}));
		B2Converter2.alphaRef=0;
		connect(B2Converter.DC,DC) annotation(Line(points={{10,0},{15,0},{15,-15},{-45,-15},{-50,-15}}));
		connect(B2Converter.Grid1,B2Converter2.Grid1) annotation(Line(points={{-10,0},{-15,0},{-10,0}}));
		connect(B2Converter2.DC,GridDC) annotation(Line(points={{10,0},{15,0},{245,0},{245,-45},{250,-45}}));
		
		
		
		if (((discharged and PRef>Pth) or (charged and PRef<-Pth)) and (PRef>Pth or PRef<-Pth)) then
			B2CController.PRef=PRef;		
		else
			B2CController.PRef=0;
		end if;
		VICAct=B2Converter.VIC;
		IDCAct=B2Converter.IDC;
		PDC=DC.I*DC.V;
		PDC_OUTPUT=GridDC.V*GridDC.I;
	annotation(
		__iti_viewinfo[0](
			simViewInfos[0](
				runtimeClass="CSimView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ModelViewInfo"),
			simViewInfos[1](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			typename="ModelInfo"),
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
				Bitmap(
					imageSource="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",
					extent={{-200,200},{200,-200}})}),
		Documentation(info="MIME-Version: 1.0
Content-Type: multipart/related;boundary=\"--$iti$\";type=\"text/html\"

----$iti$
Content-Type:text/html;charset=\"iso-8859-1\"
Content-Transfer-Encoding: quoted-printable
Content-Location: C:\\Users\\Stefan.Mohr\\AppData\\Local\\Temp\\iti4322.tmp\\hlp61ED.tmp\\BatteryCharger.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<HTML><HEAD><TITLE>Battery charger and power converter V1.0</TITLE>
<META content=3D=22text/html; charset=3Diso-8859-1=22 http-equiv=3DContent-T=
ype>
<STYLE type=3Dtext/css>
p, li =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px;=
 color: =23000000;=7D
.Ueberschrift1 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:14px; font-weight:bold; color:=23000000; margin-top:0; margin-bottom:6px=
;=7D
.Ueberschrift2 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:12px; font-weight:bold; color:=23000000; margin-top:6px; margin-bottom:6=
px;=7D
.Ueberschrift3 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:12px; font-weight:bold; font-style:italic; color:=23000000; margin-top:6=
px; margin-bottom:6px;=7D
.SymbolTab =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:=
12px; font-weight:bold; color:=23000000;=7D
</STYLE>
<LINK rel=3Dstylesheet href=3D=22../format_help.css=22>
<META name=3DGENERATOR content=3D=22MSHTML 9.00.8112.16447=22></HEAD>
<BODY bgColor=3D=23ffffff vLink=3D=23800080 link=3D=230000ff>
<P style=3D=22MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px=22 class=3DUeberschrift1>B=
attery 
charger and power converter V1.0</P>
<HR style=3D=22MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px=22 SIZE=3D1 noShade>

<TABLE border=3D1 cellSpacing=3D0 borderColor=3D=23ffffff borderColorLight=
=3D=23ffffff 
borderColorDark=3D=23ffffff cellPadding=3D2 width=3D=22100%=22 bgColor=3D=23=
cccccc>
  <TBODY>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Symbol:</P></TD>
    <TD bgColor=3D=23ffffff vAlign=3Dtop colSpan=3D3><IMG 
      src=3D=22BatteryCharger=5Csymbol.png=22 width=3D124 height=3D124></TD>=
</TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Ident:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P 
      class=3DSymbolTab>GreenBuilding.StationaryBattery.Control.BatteryCharg=
er</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Version:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab>1.0</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>File:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab></P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Connectors:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>1-phase connection to Grid</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Grid1</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>DC connection to battery</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>DC</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Reference power for charge or discharge of house =

      battery</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Control interface for battery converter</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>ControlBus</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Parameters:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Charge efficiency of battery charger</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>eta</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Number of phases of house battery charger</P></TD=
>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>ChargePhase</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Time constant of PI-controller</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TPI</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Gain constant of PI-controller</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>kPI</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum charge/discharge power</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum SOC of battery for charging</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SOCMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum SOC of battery for discharging</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SOCMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Results:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Actual intermediate circuit voltage</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>VICAct</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Actual intermediate circiut current</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>IDCAct</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR></TBODY></TABLE>
<P class=3DUeberschrift2>Description:</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>Battery converter model=
 is 
necessary to couple a DC-voltage storage (battery) with an AC-grid. Therefor=
e, 
it is possible to define a 3-phase or single-phase connection. Internally th=
e 
model either uses a B6- or B2-converter model. If the related maximum batter=
y 
voltage exceeds a value of 0.9 times of effective grid voltage, the battery =

converter has to be defined as a 3-phase converter. Maximum voltage of 3-pha=
se 
converter is 2.34 times of effective grid voltage. Using battery coverter mo=
del 
as a single-phase converter avoids high reactive power demands for voltage =

conversion.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>The battery converter i=
tself acts 
an PI-controller which controls charge and discharge power via 
intermediate-circuit voltage at DC-side depending on reference power. Make s=
ure 
that all connectors are defined with correspondent battery characteristics t=
o 
avoid numerical problems.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>The reference charge an=
d 
discharge power has to be controlled by external controllers depending inner=
 
building energy system states (e.g. renewable energy availability).</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>&nbsp;</P></BODY></HTML=
>


----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: BatteryCharger\\symbol.png

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

----$iti$--"),
		experiment(
			StopTime=1,
			StartTime=0,
			Interval=0.002,
			__iti_MaxInterval="10",
			__iti_AbsTolerance="1e-06"));
end BatteryChargerDC;
