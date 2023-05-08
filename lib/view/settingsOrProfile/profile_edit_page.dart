import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:no_name_ecommerce/services/dropdown_services/country_dropdown_service.dart';
import 'package:no_name_ecommerce/services/dropdown_services/state_dropdown_services.dart';
import 'package:no_name_ecommerce/services/profile_edit_service.dart';
import 'package:no_name_ecommerce/services/profile_service.dart';
import 'package:no_name_ecommerce/services/translate_string_service.dart';
import 'package:no_name_ecommerce/view/auth/signup/dropdowns/country_states_dropdowns.dart';
import 'package:no_name_ecommerce/view/settingsOrProfile/components/profile_helper.dart';
import 'package:no_name_ecommerce/view/settingsOrProfile/components/profile_image_pick.dart';
import 'package:no_name_ecommerce/view/utils/common_helper.dart';
import 'package:no_name_ecommerce/view/utils/const_strings.dart';
import 'package:no_name_ecommerce/view/utils/constant_colors.dart';
import 'package:no_name_ecommerce/view/utils/constant_styles.dart';
import 'package:no_name_ecommerce/view/utils/custom_input.dart';
import 'package:no_name_ecommerce/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  // String? countryCode;

  late AnimationController localAnimationController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    fullNameController.text =
        Provider.of<ProfileService>(context, listen: false)
                .profileDetails
                ?.userDetails
                .name ??
            '';

    emailController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .email ??
        '';

    phoneController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .mobile ??
        '';
    addressController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .address ??
        '';
    cityController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            ?.userDetails
            .city ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarCommon(ConstString.editProfile, context, () {
        Provider.of<ProfileEditService>(context, listen: false).setDefault();
        Navigator.pop(context);
      }, centerTitle: false, actions: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: 114,
              height: 35,
              child: borderButtonPrimary(ConstString.deleteAccount, () {
                ProfileHelper().deleteAccountPopup(context);
              },
                  fontsize: 14,
                  paddingVertical: 7,
                  borderRadius: 4,
                  borderColor: Colors.red,
                  color: Colors.red),
            ),
          ],
        )
      ]),
      body: WillPopScope(
        onWillPop: () {
          Provider.of<ProfileEditService>(context, listen: false).setDefault();
          return Future.value(true);
        },
        child: Listener(
          onPointerDown: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.focusedChild?.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenPadHorizontal, vertical: 10),
              child: Consumer<TranslateStringService>(
                builder: (context, ln, child) => Consumer<ProfileEditService>(
                  builder: (context, provider, child) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ProfileImagePick(),

                              // change image icon
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: primaryColor),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 13),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/camera-white.svg'),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      ln.getString(ConstString.changePhoto),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                          gapH(25),
                          //Name ============>
                          labelCommon(ConstString.fullName),

                          CustomInput(
                            controller: fullNameController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString(ConstString.plzEnterFullName);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterFullName),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          labelCommon(ConstString.email),
                          CustomInput(
                            controller: emailController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(ConstString.plzEnterEmail);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterEmail),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          //Phone
                          labelCommon(ConstString.phone),
                          CustomInput(
                            controller: phoneController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(ConstString.plzEnterPhone);
                              }
                              return null;
                            },
                            hintText:
                                ln.getString(ConstString.enterPhoneNumber),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                            isNumberField: true,
                          ),

                          //City
                          labelCommon(ConstString.city),
                          CustomInput(
                            controller: cityController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString(ConstString.plzEnterYourCity);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterYourCity),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          const CountryStatesDropdowns(),

                          // Zip ======>
                          gapH(18),
                          labelCommon(ConstString.zipCode),
                          CustomInput(
                            controller: zipCodeController,
                            // validation: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return ln.getString(ConstString.plzEnterZip);
                            //   }
                            //   return null;
                            // },
                            hintText: ln.getString(ConstString.enterZip),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),

                          // Address ======>
                          labelCommon(ConstString.address),
                          CustomInput(
                            controller: addressController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString(ConstString.plzEnterAddress);
                              }
                              return null;
                            },
                            hintText: ln.getString(ConstString.enterAddress),
                            paddingHorizontal: 20,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          buttonPrimary(ConstString.save, () async {
                            if (provider.isloading == false) {
                              if (_formKey.currentState!.validate()) {
                                var countryId =
                                    Provider.of<CountryDropdownService>(context,
                                            listen: false)
                                        .selectedCountryId;

                                var stateId = Provider.of<StateDropdownService>(
                                        context,
                                        listen: false)
                                    .selectedStateId;

                                if (countryId == defaultId ||
                                    stateId == defaultId) {
                                  showToast(ConstString.plzSelectCountryState,
                                      Colors.black);
                                  return;
                                }

                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.success(
                                      message: ln.getString(ConstString
                                          .updatingProfileMayTakeFewSec),
                                    ),
                                    persistent: true,
                                    onAnimationControllerInit: (controller) =>
                                        localAnimationController = controller,
                                    onTap: () {
                                      // localAnimationController.reverse();
                                    });

                                //update profile
                                var result = await provider.updateProfile(
                                    context,
                                    name: fullNameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    zip: zipCodeController.text,
                                    address: addressController.text,
                                    city: cityController.text);
                                if (result == true || result == false) {
                                  localAnimationController.reverse();
                                }
                              }
                            }
                          },
                              isloading:
                                  provider.isloading == false ? false : true,
                              borderRadius: 100),

                          gapH(25)
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
