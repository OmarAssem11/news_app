import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '/shared/cubit/cubit.dart';
//import '/modules/web_view/web_view_screen.dart';

Widget buildArticleItem(article, context, index) => Container(
      color: NewsCubit.get(context).selectedBusinessItem == index &&
              NewsCubit.get(context).isDesktop
          ? Colors.grey[200]
          : null,
      child: InkWell(
        onTap: () {
          // navigateTo(
          //   context,
          //   WebViewScreen(article['url']),
          // );
          NewsCubit.get(context).selectBusinessItem(index);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage('${article['urlToImage']}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${article['title']}',
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${article['publishedAt']}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget myDivider() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 18),
    child: Container(
      width: double.infinity,
      height: 0.5,
      color: Colors.grey,
    ),
  );
}

Widget articleBuilder(list, {isSearch = false}) {
  return ConditionalBuilder(
    condition: list.length > 0,
    builder: (context) => ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) => buildArticleItem(
        list[index],
        context,
        index,
      ),
      separatorBuilder: (context, index) => myDivider(),
      itemCount: 10,
    ),
    fallback: (context) => Center(
      child: isSearch ? Container() : CircularProgressIndicator(),
    ),
  );
}

Widget defaultFormField({
  bool isPassword = false,
  bool isClickable = true,
  bool noKeyboard = false,
  IconData? suffix,
  Function? onChange,
  Function? onSubmit,
  Function? onTap,
  Function? suffixPressed,
  required Function validate,
  required String label,
  required IconData prefix,
  required TextInputType type,
  required TextEditingController controller,
}) {
  return TextFormField(
    readOnly: noKeyboard,
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit as void Function(String)?,
    onChanged: onChange as void Function(String)?,
    onTap: onTap as void Function()?,
    enabled: isClickable,
    validator: (s) {
      return validate(s);
    },
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(
              onPressed: suffixPressed!(),
              icon: Icon(suffix),
            )
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

void navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}
