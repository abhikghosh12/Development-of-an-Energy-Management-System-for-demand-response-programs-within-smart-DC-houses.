// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model DCGRID "DCGRID.mo"
	GreenBuilding.Interfaces.Electrical.DC DC1 "DC connection after dc converter to Grid" annotation(Placement(
		transformation(extent={{155,40},{175,60}}),
		iconTransformation(extent={{90,40},{110,60}})));
	GreenBuilding.Interfaces.Electrical.DC DC2 "DC connection to battery" annotation(Placement(
		transformation(
			origin={165,20},
			extent={{-10,-10},{10,10}},
			rotation=-180),
		iconTransformation(extent={{90,-60},{110,-40}})));
	GreenBuilding.Interfaces.Electrical.DC DC3 "DC connection after dc converter to Grid" annotation(Placement(
		transformation(extent={{155,40},{175,60}}),
		iconTransformation(extent={{90,-10},{110,10}})));
	GreenBuilding.Interfaces.Electrical.DC DC4 "DC connection after dc converter to Grid" annotation(Placement(
		transformation(extent={{45,15},{65,35}}),
		iconTransformation(extent={{-110,-60},{-90,-40}})));
	GreenBuilding.Interfaces.Electrical.DC DC5 "DC connection after dc converter to Grid" annotation(Placement(
		transformation(extent={{45,15},{65,35}}),
		iconTransformation(extent={{-10,90},{10,110}})));
	GreenBuilding.Interfaces.Electrical.DC DC6 "DC connection after dc converter to Grid" annotation(Placement(
		transformation(extent={{45,15},{65,35}}),
		iconTransformation(extent={{-60,90},{-40,110}})));
	input Modelica.Blocks.Interfaces.RealOutput voltage(
		quantity="Electricity.Voltage",
		displayUnit="V") "Control voltage " annotation(
		Placement(
			transformation(
				origin={205,-135},
				extent={{-10,-10},{10,10}},
				rotation=-90),
			iconTransformation(
				origin={0,-100},
				extent={{-10,-10},{10,10}},
				rotation=-90)),
		Dialog(
			group="Voltage",
			tab="Results 1",
			showAs=ShowAs.Result));
	GreenBuilding.Interfaces.Electrical.ExtractCurrentDC extractCurrentDC1 "Specifies voltage, extracts current of a DC connector" annotation(Placement(transformation(extent={{45,40},{65,60}})));
	GreenBuilding.Interfaces.Electrical.ExtractCurrentDC extractCurrentDC2 annotation(Placement(transformation(extent={{45,15},{65,35}})));
	GreenBuilding.Interfaces.Electrical.ExtractCurrentDC extractCurrentDC3 annotation(Placement(transformation(extent={{-200,-20},{65,0}})));
	GreenBuilding.Interfaces.Electrical.ExtractCurrentDC extractCurrentDC4 annotation(Placement(
		transformation(extent={{155,40},{175,60}}),
		iconTransformation(extent={{190,-110},{210,-90}})));
	GreenBuilding.Interfaces.Electrical.ExtractCurrentDC extractCurrentDC5 annotation(Placement(
		transformation(extent={{155,40},{175,60}}),
		iconTransformation(extent={{190,-110},{210,-90}})));
	GreenBuilding.Interfaces.Electrical.ExtractCurrentDC extractCurrentDC6 annotation(Placement(
		transformation(extent={{155,40},{175,60}}),
		iconTransformation(extent={{190,-110},{210,-90}})));
	Real ESupply(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy supply" annotation(Dialog(
		group="Energy",
		tab="Results 2",
		showAs=ShowAs.Result));
	Real Efeed(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy feed" annotation(Dialog(
		group="Energy",
		tab="Results 2",
		showAs=ShowAs.Result));
	Real PDCinput(
		quantity="Basics.Power",
		displayUnit="kW") "DC input power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real PDCoutput(
		quantity="Basics.Power",
		displayUnit="kW") "DC output power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real EXCESS(
		quantity="Basics.Power",
		displayUnit="kW") "DC output excess power" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	equation
		extractCurrentDC1.V=voltage ;
		extractCurrentDC2.V=voltage ;
		extractCurrentDC3.V=voltage ;
		extractCurrentDC4.V=voltage ;
		extractCurrentDC5.V=voltage ;
		extractCurrentDC6.V=voltage ;
		
		PDCinput= extractCurrentDC4.I * voltage;
		
		PDCoutput=extractCurrentDC1.I * voltage + extractCurrentDC2.I * voltage + extractCurrentDC3.I * voltage + extractCurrentDC5.I * voltage + extractCurrentDC6.I * voltage; 
		EXCESS = -PDCoutput + PDCinput;
		der(ESupply)=PDCoutput;
		der(Efeed)=PDCinput;
		
			connect(DC1,extractCurrentDC1.FlowCurrent) annotation(Line(points={{165,50},{160,50},{70,50},{65,50}}));
			connect(DC2,extractCurrentDC2.FlowCurrent) annotation(Line(points={{165,20},{160,20},{70,20},{70,25},{65,25}}));
			connect(DC1,extractCurrentDC5.FlowCurrent) annotation(Line(points={{165,50},{160,50},{70,50},{65,50}}));
			connect(DC1,extractCurrentDC6.FlowCurrent) annotation(Line(points={{165,50},{160,50},{70,50},{65,50}}));
			
			
			connect(DC3,extractCurrentDC3.FlowCurrent) annotation(Line(points={{170,-10},{165,-10},{70,-10},{65,-10}}));
			connect(extractCurrentDC4.FlowCurrent,DC4) annotation(Line(
				points={{-60,60},{-65,60},{-100,60},{-105,60}},
				color={247,148,29},
				thickness=0.0625));
	annotation(
		DC4(
			V(flags=2),
			I(flags=2)),
		experiment(
			StopTime=86400,
			StartTime=0,
			Tolerance=1e-006,
			Interval=172.8,
			MinInterval="1e-009",
			MaxInterval="10",
			AbsTolerance="1e-06"));
end DCGRID;
