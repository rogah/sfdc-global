public class RandomUtils {
	public static Integer getRandomInteger() {
    	return getRandomInteger(1, 2147483647);
    }
    
    public static Integer getRandomInteger(Integer lower, Integer upper) {
    	return (Integer) (Math.floor(Math.random() * (upper - lower)) + lower);
    }
}