// Represents the seller information displayed in the contact bar
class SellerModel {
  final String name;
  final String imageUrl; // URL for the profile picture

  SellerModel({
    required this.name,
    required this.imageUrl,
  });

  // Dummy data factory
  factory SellerModel.dummy() {
    return SellerModel(
      name: "احمد خالد", // Name from the example image
      // Using a placeholder image URL - replace with a real one if available
      // or leave as is for initial UI building.
      imageUrl:
          "https://s3-alpha-sig.figma.com/img/025b/2128/cc0250d37d3c563c2cb95df2ca13eae5?Expires=1744588800&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=cVr75zz~a3-NZCR46APZ5aFNvDLRoMyZc6VneCVGQSR4qQcoxYrJLMXjkhjljWVEE-TAJkh8XoE3lbA5bpGcSRsC5L4VzW~fnn0qSRsBQRwy~~sfiNY2m4iU0Ss~tpqZnWFPH9-y9w2Ee2mjRPe15R1ch6bDKgrtcm99KGv~oPoS4pk2PgWE9gPdzUP62eHksjgQDH3CetJUs8ss6tskcWXGAJTYVwaipNqAcgeKUo-diOM2zFfKEq705kV9RP2~SYqiuQMHPXVjEJI8AKhKWUBtyuvyNapAW0G23NKhI4~DH9BHnAkE1X4W98DiiAZ2qOiepmvd53tyUCs5TsNQ5Q__",
    );
  }
}
