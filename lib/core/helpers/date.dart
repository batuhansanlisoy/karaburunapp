class DateHelper {
    // yyyy-MM-dd → dd/MM/yyyy
    static String formatToDayMonthYear(String date) {
        try {
            final parsedDate = DateTime.parse(date);
            final day = parsedDate.day.toString().padLeft(2, '0');
            final month = parsedDate.month.toString().padLeft(2, '0');
            final year = parsedDate.year.toString();
            return "$day/$month/$year";
        } catch (e) {
            return date; // parse edilemezse olduğu gibi döndür
        }
    }

    // DateTime → dd/MM/yyyy
    static String formatDateTime(DateTime dateTime) {
        final day = dateTime.day.toString().padLeft(2, '0');
        final month = dateTime.month.toString().padLeft(2, '0');
        final year = dateTime.year.toString();
        return "$day/$month/$year";
    }

    // İsteğe bağlı: sadece ay-gün formatı
    static String formatToDayMonth(String date) {
        try {
            final parsedDate = DateTime.parse(date);
            final day = parsedDate.day.toString().padLeft(2, '0');
            final month = parsedDate.month.toString().padLeft(2, '0');
            return "$day/$month";
        } catch (e) {
            return date;
        }
    }
}
