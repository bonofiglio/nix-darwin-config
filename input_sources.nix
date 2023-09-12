{ config, lib, pkgs, ... }:
let
    boolValue = x: if x then "YES" else "NO";

    toXml = xmlValue: with builtins;
        if isBool xmlValue then "<bool>${boolValue xmlValue}</bool>" else
        if isInt xmlValue then "<integer>${toString xmlValue}</integer>" else
        if isFloat xmlValue then "<float>${strings.floatToString xmlValue}</float>" else
        if isString xmlValue then "<string>${xmlValue}</string>" else
        if isList xmlValue then "<array>" + concatStringsSep "" (map (x: toXml x) xmlValue) + "</array>" else
        if isAttrs xmlValue then "<dict>" + (concatStringsSep "" (map (key: "<key>${key}</key>${toXml (getAttr key xmlValue)}") (attrNames xmlValue))) + "</dict>" else
        throw "invalid value type";
in
{
    system.activationScripts.extraUserActivation.text = ''
        defaults write com.apple.HIToolbox AppleEnabledInputSources "${toXml [
            {
                    InputSourceKind = "Keyboard Layout";
                    "KeyboardLayout ID" = 252;
                    "KeyboardLayout Name" = "ABC";
            }
            {
                InputSourceKind = "Keyboard Layout";
                "KeyboardLayout ID" = 87;
                "KeyboardLayout Name" = "Spanish - ISO";
            }
        ]}"
    '';
} 
