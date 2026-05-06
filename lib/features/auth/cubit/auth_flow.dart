enum AuthFlow {
  splash,
  onboarding,
  signUp,
  signIn,

  /// After email login: collect experience + goal, then [authenticated].
  postLoginSetup,
  authenticated,
}
