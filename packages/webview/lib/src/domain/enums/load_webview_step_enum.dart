enum LoadWebviewStepEnum {
  error(0),
  webViewCreated(1),
  loadStarted(2),
  progressChanged(3),
  pageVisible(4),
  loadStopped(5),
  successLoaded(6);

  final int priority;

  const LoadWebviewStepEnum(this.priority);

  bool get isFinished => isSuccessStep || isErrorStep;

  bool get isSuccessStep {
    return this == LoadWebviewStepEnum.successLoaded;
  }

  bool get isErrorStep {
    return this == LoadWebviewStepEnum.error;
  }

  bool get isOnLoadStartedStep {
    return this == LoadWebviewStepEnum.loadStarted;
  }

  bool get isOnProgressChangedStep {
    return this == LoadWebviewStepEnum.progressChanged;
  }

  bool get isGreaterThanProgressStep {
    return priority >= LoadWebviewStepEnum.progressChanged.priority;
  }

  bool get isOnPageVisibleStep {
    return this == LoadWebviewStepEnum.pageVisible;
  }

  bool get isOnLoadStoppedStep {
    return this == LoadWebviewStepEnum.loadStopped;
  }

  // static List<LoadWebviewStepEnum> get loadedWebViewSteps {
  //   return [LoadWebviewStepEnum.loadStopped, LoadWebviewStepEnum.successLoaded];
  // }
}
