enum LivenessEnvironments {
  prd(value: "PRD"),
  hml(value: "HML");

  final String value;

  const LivenessEnvironments({required this.value});
}