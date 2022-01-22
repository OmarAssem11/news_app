import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/modules/business/business_screen.dart';
import '/modules/science/science_screen.dart';
import '/modules/sports/sports_screen.dart';
import '/shared/cubit/states.dart';
import '/shared/network/local/cache_helper.dart';
import '/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(index) {
    currentIndex = index;
    if (index == 1) {
      getSports();
    } else if (index == 2) {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  List business = [];
  int selectedBusinessItem = 0;
  bool isDesktop = false;
  //List<bool> businessSelectedItem = [];

  void setDesktop(bool value) {
    isDesktop = value;
    emit(NewsSetDesktopState());
  }

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    DioHelper.getData(
      url: 'v2/top-headlines/',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': 'a8a062e5d45b406ab81a8e9a5a2a6cfb',
      },
    ).then((value) {
      business = value.data['articles'];
      // business.forEach((element) {
      //   businessSelectedItem.add(false);
      // });
      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  void selectBusinessItem(index) {
    // for (int i = 0; i < businessSelectedItem.length; i++) {
    //   if (i == index)
    //     businessSelectedItem[i] = true;
    //   else
    //     businessSelectedItem[i] = false;
    // }
    selectedBusinessItem = index;
    emit(NewsSelectBusinessItemState());
  }

  List sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());
    if (sports.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines/',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': 'a8a062e5d45b406ab81a8e9a5a2a6cfb',
        },
      ).then((value) {
        sports = value.data['articles'];
        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());
    if (science.length == 0) {
      DioHelper.getData(
        url: 'v2/top-headlines/',
        query: {
          'country': 'eg',
          'category': 'science',
          'apiKey': 'a8a062e5d45b406ab81a8e9a5a2a6cfb',
        },
      ).then((value) {
        science = value.data['articles'];
        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  bool isDark = false;

  void changeAppMode({fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(NewsChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBool(key: 'isDark', value: isDark).then(
        (value) => emit(NewsChangeModeState()),
      );
    }
  }

  List search = [];

  void getSearch(String value) {
    emit(NewsGetSearchLoadingState());
    DioHelper.getData(
      url: 'v2/everything/',
      query: {
        'q': '$value',
        'apiKey': 'a8a062e5d45b406ab81a8e9a5a2a6cfb',
      },
    ).then((value) {
      search = value.data['articles'];
      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}
