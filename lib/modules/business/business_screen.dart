import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '/shared/components/components.dart';
import '/shared/cubit/cubit.dart';
import '/shared/cubit/states.dart';

class BusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var list = NewsCubit.get(context).business;

        return ScreenTypeLayout(
          mobile: Builder(builder: (context) {
            NewsCubit.get(context).setDesktop(false);
            return articleBuilder(list);
          }),
          desktop: Builder(builder: (context) {
            NewsCubit.get(context).setDesktop(true);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: articleBuilder(list),
                ),
                if (list.length > 0)
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          '${list[NewsCubit.get(context).selectedBusinessItem]['description']}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          breakpoints: ScreenBreakpoints(
            desktop: 600,
            tablet: 600,
            watch: 100,
          ),
        );
      },
    );
  }
}
