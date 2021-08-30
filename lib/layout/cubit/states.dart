abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsBottomNavState extends NewsStates {}

//business
class NewsGetBusinessDataSuccessState extends NewsStates {}

class NewsGetBusinessDataErrorState extends NewsStates {
  late final String error;

  NewsGetBusinessDataErrorState(this.error);
}

class NewsGetBusinessLoadingState extends NewsStates {}

class NewsGetScienceDataSuccessState extends NewsStates {}

//science
class NewsGetScienceDataErrorState extends NewsStates {
  late final String error;

  NewsGetScienceDataErrorState(this.error);
}

class NewsGetScienceLoadingState extends NewsStates {}

//Sports
class NewsGetSportsDataSuccessState extends NewsStates {}

class NewsGetSportsDataErrorState extends NewsStates {
  late final String error;

  NewsGetSportsDataErrorState(this.error);
}

class NewsGetSportsLoadingState extends NewsStates {}

//Search

class NewsGetSearchDataSuccessState extends NewsStates {}

class NewsGetSearchDataErrorState extends NewsStates {
  late final String error;

  NewsGetSearchDataErrorState(this.error);
}

class NewsGetSearchLoadingState extends NewsStates {}
