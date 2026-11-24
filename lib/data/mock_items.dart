// ===========================================================================
// مفقوداتي - Campus Lost & Found
// lib/data/mock_items.dart
// Owner: Team Lead / All Members (shared sample data)
// Description: Pre-populated realistic Arabic campus sample data for 6 items
//   so the app looks rich immediately on first launch.
// ===========================================================================

import '../models/lost_item_model.dart';

class MockItems {
  MockItems._();

  static AppState createInitialState() {
    final now = DateTime.now();

    final items = <LostItem>[
      LostItem(
        id: 'item_1',
        title: 'كارنيه كلية حاسبات ومعلومات',
        description:
            'كارنيه جامعي باسم أحمد محمود، الفرقة الثالثة شعبة علوم الحاسب. على ظهره ستيكر أزرق صغير.',
        location: 'مدرج 3 - الدور الأرضي',
        category: ItemCategory.idCard,
        contactPhone: '01012345678',
        reporterName: 'أحمد محمود',
        date: now.subtract(const Duration(hours: 3)),
        isLost: true,
      ),
      LostItem(
        id: 'item_2',
        title: 'سماعة AirPods بيضاء',
        description:
            'سماعة AirPods Pro الجيل الثاني، الكيس الخاص بيها لون أبيض ومكتوب عليه اسم بالأحمر. فُقدت أثناء المحاضرة.',
        location: 'مدرج 3 - الصف الأمامي',
        category: ItemCategory.electronics,
        contactPhone: '01198765432',
        reporterName: 'سارة حسام',
        date: now.subtract(const Duration(hours: 7)),
        isLost: true,
      ),
      LostItem(
        id: 'item_3',
        title: 'مفاتيح سيارة بميدالية زرقاء',
        description:
            'مفاتيح سيارة كيا سبورتاج، معاها ميدالية بلاستيك زرقاء وكيهولدر شكل قلب. تم العثور عليها قرب المدخل الرئيسي.',
        location: 'الكافيتريا الرئيسية',
        category: ItemCategory.keys,
        contactPhone: '01123456789',
        reporterName: 'محمود طارق',
        date: now.subtract(const Duration(days: 1)),
        isLost: false,
      ),
      LostItem(
        id: 'item_4',
        title: 'شاحن لابتوب Dell أسود',
        description:
            'شاحن Dell الأصلي، الكابل فيه شريط لاصق بيج. نُسي في معمل البرمجة على الطاولة رقم 7.',
        location: 'معمل البرمجة - الدور الثاني',
        category: ItemCategory.electronics,
        contactPhone: '01056781234',
        reporterName: 'عمر فتحي',
        date: now.subtract(const Duration(days: 1, hours: 5)),
        isLost: true,
      ),
      LostItem(
        id: 'item_5',
        title: 'شنطة ظهر رمادية (Adidas)',
        description:
            'شنطة ظهر Adidas رمادية بشريط أسود، جوّاها كتب مناهج الفرقة الثانية وعليها اسم المالك بالقلم.',
        location: 'المكتبة - قسم الدراسة الهادئة',
        category: ItemCategory.bagAndBooks,
        contactPhone: '01234567890',
        reporterName: 'نادية علي',
        date: now.subtract(const Duration(days: 2)),
        isLost: false,
        isResolved: true,
      ),
      LostItem(
        id: 'item_6',
        title: 'نظارة طبية بإطار بني',
        description:
            'نظارة طبية Ray-Ban بإطار بني، في علبة سوداء مكتوب عليها اسم الصيدلية. صاحبها محتاجها ضرورة.',
        location: 'مدرج 1 - الدور الأول',
        category: ItemCategory.other,
        contactPhone: '01187654321',
        reporterName: 'كريم سعيد',
        date: now.subtract(const Duration(days: 3)),
        isLost: true,
      ),
    ];

    return AppState(initialItems: items);
  }
}
