#! /bin/bash

# print usage if #arg < 4
[ "$#" -lt 4 ] && echo "Usage: ios2and in out prefix postfix"\
    && exit 0

# Android XML string header
# Assume path to $2 exists.
echo "Add $3 to $2"
cp $3 $2

echo "Convert iOS format to XML."
sed 's@^\(".*"\) = "\(.*\)";$@    <string name=\1>\2</string>@g' $1 >> $2

# Must handle '&' first, cause other conversion might contains '&'.
echo "Convert '&' to \"&amp;\""
sed -i.bak 's/&/&amp;/g' $2

echo "Convert '!' to \"&#x21;\""
sed -i.bak 's/!/\&#x21;/g' $2

echo "Convert ''' to \"\\'\""
sed -i.bak "s/'/\\\\'/g" $2

# Delete temp file
rm $2.bak

# Android XML string footer
echo "Add $4 to $2"
cat $4 >> $2

