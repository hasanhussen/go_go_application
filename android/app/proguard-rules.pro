-keep class com.stripe.android.** { *; }
-keep class com.stripe.android.payments.paymentlauncher.** { *; }
-keep class com.stripe.android.model.** { *; }
-keep class com.stripe.android.view.** { *; }
-keep class com.stripe.android.PaymentConfiguration { *; }

# keep parcelable models
-keepclassmembers class ** implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
