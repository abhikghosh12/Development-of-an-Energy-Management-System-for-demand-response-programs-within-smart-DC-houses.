// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model Housepowercontroller_all "Housepowercontroller_all.mo"
	GreenBuilding.Interfaces.Electrical.DC DCinput "DC connection to PV system" annotation(Placement(
		transformation(extent={{45,-25},{65,-5}}),
		iconTransformation(extent={{90,-10},{110,10}})));
	GreenBuilding.Interfaces.Electrical.DC DCoutput "DC connection to PV system" annotation(Placement(
		transformation(extent={{45,-25},{65,-5}}),
		iconTransformation(extent={{-110,-10},{-90,10}})));
	GreenBuilding.Interfaces.Battery.BatteryBus ControlBus "Control interface for battery converter" annotation(Placement(
		transformation(extent={{-60,-120},{-40,-100}}),
		iconTransformation(extent={{-10,-110},{10,-90}})));
	GreenBuilding.Interfaces.Electrical.DefineCurrentDC GridConnection annotation(
		Placement(transformation(
			origin={240,-70},
			extent={{10,-10},{-10,10}},
			rotation=90)),
		Dialog(
			group="Coefficient of Performance",
			tab="Results 1"));
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
				origin={0,100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	Real VICAct(
		quantity="Electricity.Voltage",
		displayUnit="V") "Actual intermediate circuit voltage" annotation(Dialog(
		group="Voltage",
		tab="Results",
		showAs=ShowAs.Result));
	Real IDCAct(
		quantity="Electricity.Current",
		displayUnit="A") "Actual intermediate circiut current" annotation(Dialog(
		group="Current",
		tab="Results",
		showAs=ShowAs.Result));
	Boolean charged(fixed=false) "Vehicle battery has been charged after underrun SOC minimum level" annotation(Dialog(
		group="Control",
		tab="Results",
		showAs=ShowAs.Result));
	Boolean discharged(fixed=true) "Vehicle battery has beed discharged after overrun SOC maximun level" annotation(Dialog(
		group="Control",
		tab="Results",
		showAs=ShowAs.Result));
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
	Real PDCinput(
		quantity="Basics.Power",
		displayUnit="kW") "DC power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real PDCoutput(
		quantity="Basics.Power",
		displayUnit="kW") "DC power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real ECP(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy of circulation pump" annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	parameter Real alpha=0.97222222222222221 "duty cycle" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	equation
		if   (PRef> 0)  then
			charged=true;
		discharged=false;
			else 
			charged=false;
			discharged=true;
		end if;
		der(ECP)=PDCoutput;
			PDCinput= DCinput.I* DCinput.V;
			
			GridConnection.V = 48;
			if charged  then
							if (GridConnection.V >1e-10) then
							
								GridConnection.I=-(((PDCinput*alpha)/GridConnection.V)*10000);
							
							else
								GridConnection.I=0;
								
							end if;
		
		     else 
		                    if (GridConnection.V >1e-10) then
							
								GridConnection.I=(((PDCinput*alpha)/GridConnection.V)*10000);
							
							else
								GridConnection.I=0;
								
							end if;
			
		      end if;      
		      PDCoutput=abs(GridConnection.I*GridConnection.V);          
							connect(DCoutput,GridConnection.FlowCurrent) annotation(Line(points={{55,-15},{60,-15},{60,-85},{240,-85},{240,-80}}));
	annotation(
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		experiment(
			StopTime=86400,
			StartTime=0,
			Tolerance=1e-006,
			Interval=172.8,
			MinInterval="1e-009",
			MaxInterval="10",
			AbsTolerance="1e-06"));
end Housepowercontroller_all;
