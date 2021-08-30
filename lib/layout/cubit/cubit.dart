import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/states.dart';
import 'package:todo_app/modules/business/business_screen.dart';
import 'package:todo_app/modules/science/science_screen.dart';
import 'package:todo_app/modules/settings_screen/settings_screen.dart';
import 'package:todo_app/modules/sports/sports_screen.dart';
import 'package:todo_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: "Business",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: "Sport",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: "Science",
    ),
  ];

  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    if (index == 1) getSports();
    if (index == 2) getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];
  List<dynamic> science = [];
  List<dynamic> sports = [];
  List<dynamic> search = [];

  void getBusiness() {
    if (business.length > 0) {
      emit(NewsGetBusinessDataSuccessState());
      return;
    }
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: "v2/top-headlines",
      query: {
        "country": "eg",
        "category": "business",
        "apiKey": "75977c933e8d47c6a7b86b550c7b27eb",
      },
    ).then((value) {
      business = value.data['articles'];
      print(business);
      emit(NewsGetBusinessDataSuccessState());
    }).catchError((error) {
      emit(NewsGetBusinessDataErrorState(error.toString()));
    });
  }

  void getScience() {
    if (science.length > 0) {
      emit(NewsGetScienceDataSuccessState());
      return;
    }
    emit(NewsGetScienceLoadingState());
    DioHelper.getData(
      url: "v2/top-headlines",
      query: {
        "country": "eg",
        "category": "science",
        "apiKey": "75977c933e8d47c6a7b86b550c7b27eb",
      },
    ).then((value) {
      science = value.data['articles'];
      emit(NewsGetScienceDataSuccessState());
    }).catchError((error) {
      emit(NewsGetScienceDataErrorState(error.toString()));
    });
  }

  void getSports() {
    if (sports.length > 0) {
      emit(NewsGetSportsDataSuccessState());
      return;
    }
    emit(NewsGetSportsLoadingState());
    DioHelper.getData(
      url: "v2/top-headlines",
      query: {
        "country": "eg",
        "category": "sports",
        "apiKey": "75977c933e8d47c6a7b86b550c7b27eb",
      },
    ).then((value) {
      sports = value.data['articles'];
      emit(NewsGetSportsDataSuccessState());
    }).catchError((error) {
      emit(NewsGetSportsDataErrorState(error.toString()));
    });
  }

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
      url: "v2/everything",
      query: {
        "q": "$value",
        "apiKey": "75977c933e8d47c6a7b86b550c7b27eb",
      },
    ).then(
      (value) {
        search = value.data['articles'];
        emit(NewsGetSearchDataSuccessState());
      },
    ).catchError(
      (error) {
        emit(NewsGetSearchDataErrorState(error.toString()));
      },
    );
  }
}
