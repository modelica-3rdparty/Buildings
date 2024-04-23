within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses;
model Effectiveness
  "Model for calculating the heat exchange effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Efficiency epsCoo_nominal(final max=1)
    "Nominal sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsCooPL(final max=1)
    "Part load (75% of the nominal supply flow rate) sensible heat exchanger effectiveness at the cooling mode";
  parameter Modelica.Units.SI.Efficiency epsHea_nominal(final max=1)
    "Nominal sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.Efficiency epsHeaPL(final max=1)
    "Part load (75% of the nominal supply flow rate) sensible heat exchanger effectiveness at the heating mode";
  parameter Modelica.Units.SI.VolumeFlowRate VSup_flow_nominal
    "Nominal supply air flow rate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Exhaust air temperature
    " annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSup_flow(final unit="m3/s")
    "Supply air volumetric flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VExh_flow( final unit="m3/s")
    "Exhaust air volumetric flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eps(final unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Real rat
    "Ratio of the average operating air flow rate to the nominal supply air flow rate";
  Real epsPL
    "Part load sensible heat exchanger effectiveness used for calculation";
  Real eps_nominal
    "Nominal sensible heat exchanger effectiveness used for calculation";

equation
  // Check if the air flows are too unbalanced
  assert(VSup_flow - 2*VExh_flow < 0 or VExh_flow - 2*VSup_flow < 0,
    "In " + getInstanceName() + ": The ratio of the supply flow rate to the exhaust flow rate should be in the range of [0.5, 2].",
    level=AssertionLevel.warning);
  // Calculate the average volumetric air flow and flow rate ratio.
  rat = (VSup_flow + VExh_flow)/2/VSup_flow_nominal;
  // Check if the extrapolation goes too far
  assert(rat > 0.5 and rat < 1.3,
    "In " + getInstanceName() + ": The ratio of the operating flow rate to the nominal supply flow rate should be in the range of [0.5, 1.3].",
    level=AssertionLevel.warning);
  // Switch between cooling and heating modes based on the difference between the supply air temperature and the exhaust air temperature
  epsPL = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsCooPL, epsHeaPL, 1e-5);
  eps_nominal = Buildings.Utilities.Math.Functions.regStep(TSup-TExh, epsCoo_nominal, epsHea_nominal, 1e-5);
  // Calculate effectiveness
  eps =uSpe*(epsPL + (eps_nominal - epsPL)*(rat - 0.75)/0.25);
  assert(eps >= 0 and eps < 1,
    "In " + getInstanceName() + ": The sensible heat exchange effectiveness eps = " + String(eps) + ". It should be in the range of [0, 1].
    Check if the part load (75% of the nominal supply flow rate) or nominal sensible heat exchanger effectiveness is too high or too low.",
    level=AssertionLevel.error);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-54,28},{50,-40}},
          textColor={28,108,200},
          textString="eps")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="effCal",
Documentation(info="<html>
<p>
This block calculates the sensible effectiveness of the heat exchanger
under heating and cooling modes at different flow rates of the supply
air and the exhaust air.
</p>
<p>
It firstly calculates the ratio of the average operating flow rate to the nominal
supply flow rate by:
</p>
<pre>
  rat = (VSup_flow + VExh_flow)/(2*VSup_flow_nominal),
</pre>
<p>
where <code>VSup_flow</code> is the flow rate of the supply air;
<code>VExh_flow</code> is the flow rate of the exhaust air;
<code>VSup_flow_nominal</code> is the nominal flow rate of the supply air; and 
<code>rat</code> is the flow ratio.
</p>
<p>
It then calculates the sensible heat exchanger effectiveness by:
</p>
<pre>
  eps = uSpe * (epsPL + (eps_nominal - epsPL) * (rat - 0.75)/0.25),
</pre>
<p>
where <code>eps</code> is the effectiveness
for the sensible heat transfer, respectively;
<code>eps_nominal</code> and <code>epsPL</code> are the effectiveness 
for the sensible heat transfer when <code>rat</code> is 1 and 0.75, respectively.
<code>uSpe</code> is the speed ratio of a rotary wheel.
</p>
<p>
The parameters <code>eps_nominal</code> and <code>epsPL</code>
have different values depending on if the wheel is in
the cooling or heating mode.
If the supply air temperature is greater than the exhaust air 
temperature, the exchanger is considered to operate under
the cooling mode;
Otherwise, it operates under the heating mode.
</p>
<P>
<b>Note:</b> 
The value of the <code>rat</code> is suggested to be between <i>0.5</i> and <i>1.3</i>, 
to ensure reasonable extrapolation.
Likewise, an unbalanced air flow ratio less than 2,  i.e., <code>VSup_flow/VExh_flow</code> &#62; <i>0.5</i> 
and <code>VSup_flow/VExh_flow</code> &#60; <i>2</i>, is recommended.
</P>
<h4>References</h4>
U.S. Department of Energy 2016.
&quot;EnergyPlus Engineering Reference&quot;.
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Effectiveness;