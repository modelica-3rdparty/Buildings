within Buildings.Fluid.Storage.Plant.Validation;
model NetworkConnection
  "Validation model for the pump, valves, and their control"

  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  final parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    allowRemoteCharging=true,
    mTan_flow_nominal=1,
    mChi_flow_nominal=1E-5,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.TimeTable mSet_flow(table=[0,0; 900,0; 900,1; 1800,1;
        1800,-1; 2700,-1; 2700,1; 3600,1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isRemCha(t=1E-5)
    "Tank is being charged when the flow setpoint is negative"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Blocks.Sources.BooleanTable uAva(
    final table={900},
    final startValue=false)
    "Plant availability"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom,
    final allowRemoteCharging=nom.allowRemoteCharging,
    final perPumSup(pressure(V_flow=nom.m_flow_nominal/1.2*{0,2},
                             dp=nom.dp_nominal*{2,0})))
    "Pump and valves connecting the storage plant to the district network"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "Mass flow rate to the supply line"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idePreSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=false,
    final control_dp=true)
    "Ideal pressure source representing a remote chiller plant" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,0})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroNet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.9)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,0})));
  Modelica.Blocks.Sources.Constant dp(final k=-nom.dp_nominal*0.3)
    "Constant differential pressure"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Fluid.FixedResistances.Junction junSup(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.FixedResistances.Junction junRet(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the return side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-30})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 101325,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-70})));
  Buildings.Fluid.FixedResistances.Junction junBou(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={nom.m_flow_nominal,-nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction for the pressure boundary"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(conRemCha.yPumSup, netCon.yPumSup)
    annotation (Line(points={{-12,39},{-12,11}},
                                             color={0,0,127}));
  connect(conRemCha.yValSup, netCon.yValSup)
    annotation (Line(points={{-8,39},{-8,11}}, color={0,0,127}));
  connect(mSet_flow.y, conRemCha.mTanSet_flow) annotation (Line(points={{-79,90},
          {-30,90},{-30,58},{-21,58}},color={0,0,127}));
  connect(mSet_flow.y, isRemCha.u)
    annotation (Line(points={{-79,90},{-22,90}},color={0,0,127}));
  connect(isRemCha.y, conRemCha.uRemCha) annotation (Line(points={{2,90},{8,90},
          {8,58},{2,58}},   color={255,0,255}));
  connect(conRemCha.uAva, uAva.y) annotation (Line(points={{2,54},{46,54},{46,
          90},{41,90}}, color={255,0,255}));
  connect(senMasFlo.m_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-50,41},{-50,54},{-21,54}}, color={0,0,127}));
  connect(netCon.port_aFroChi,senMasFlo. port_b) annotation (Line(points={{-20,6},
          {-34,6},{-34,30},{-40,30}}, color={0,127,255}));
  connect(dp.y, idePreSou.dp_in) annotation (Line(points={{21,-70},{30,-70},{30,
          6},{42,6}}, color={0,0,127}));
  connect(junSup.port_2, preDroNet.port_a)
    annotation (Line(points={{60,30},{90,30},{90,10}}, color={0,127,255}));
  connect(preDroNet.port_b, junRet.port_1)
    annotation (Line(points={{90,-10},{90,-30},{60,-30}}, color={0,127,255}));
  connect(junRet.port_3, idePreSou.port_a)
    annotation (Line(points={{50,-20},{50,-10}}, color={0,127,255}));
  connect(idePreSou.port_b, junSup.port_3)
    annotation (Line(points={{50,10},{50,20}}, color={0,127,255}));
  connect(netCon.port_bToNet, junSup.port_1) annotation (Line(points={{0,6},{20,
          6},{20,30},{40,30}}, color={0,127,255}));
  connect(junRet.port_2, netCon.port_aFroNet) annotation (Line(points={{40,-30},
          {20,-30},{20,-6},{0,-6}}, color={0,127,255}));
  connect(netCon.port_bToChi, junBou.port_2) annotation (Line(points={{-20,-6},{
          -34,-6},{-34,-30},{-40,-30}}, color={0,127,255}));
  connect(junBou.port_1, senMasFlo.port_a) annotation (Line(points={{-60,-30},{-64,
          -30},{-64,30},{-60,30}}, color={0,127,255}));
  connect(bou.ports[1], junBou.port_3) annotation (Line(points={{-80,-70},{-50,-70},
          {-50,-40}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/NetworkConnection.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
[]
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end NetworkConnection;