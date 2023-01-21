rm -rf build/web
flutter build web
staticrypt build/web/index.html handballdigital2023
rm build/web/index.html
mv build/web/index_encrypted.html build/web/index.html
firebase deploy