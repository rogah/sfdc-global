public Class SystemUtils {
    public static String generateUUID() {
        Blob aes = Crypto.generateAesKey(128);
        return EncodingUtil.convertToHex(aes);
    }
}