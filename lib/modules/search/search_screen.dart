import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/components/components.dart';
import '/shared/cubit/cubit.dart';
import '/shared/cubit/states.dart';

class SrearchScreen extends StatelessWidget {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: defaultFormField(
                  validate: (String value) {
                    if (value.isEmpty) {
                      return 'Search must not be empty';
                    } else {
                      return null;
                    }
                  },
                  label: 'Search',
                  prefix: Icons.search,
                  type: TextInputType.text,
                  controller: searchController,
                  onChange: (value) {
                    NewsCubit.get(context).getSearch(value);
                  },
                ),
              ),
              Expanded(
                child: articleBuilder(
                  list,
                  isSearch: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
