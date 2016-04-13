package com.example.hamilyjing.jj_android_service.Tool;

import java.security.MessageDigest;

/**
 * Created by JJ on 4/13/16.
 */
public class JJMD5 {
    private MessageDigest messageDigest;

    public JJMD5() {
        try {
            this.messageDigest = MessageDigest.getInstance("MD5");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    static public String md5(String string) {
        if (null == string || string.length() <= 0)
        {
            return "";
        }

        JJMD5 md5 = new JJMD5();
        String md5String = md5.compute(string);
        return md5String;
    }

    public String compute(String string) {

        char[] charArray = string.toCharArray();

        byte[] byteArray = new byte[charArray.length];

        for (int i = 0; i < charArray.length; i++)
            byteArray[i] = (byte) charArray[i];

        byte[] md5Bytes = this.messageDigest.digest(byteArray);

        StringBuffer hexValue = new StringBuffer();

        for (int i = 0; i < md5Bytes.length; i++) {
            int val = ((int) md5Bytes[i]) & 0xff;
            if (val < 16)
                hexValue.append("0");
            hexValue.append(Integer.toHexString(val));
        }

        return hexValue.toString();
    }

    public MessageDigest getMessageDigest() {
        return messageDigest;
    }

    public void setMessageDigest(MessageDigest messageDigest) {
        this.messageDigest = messageDigest;
    }
}
