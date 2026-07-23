# Balhareth Ortho — initial content.
# English copy comes from the approved content document (BalHarith Website.pdf,
# July 2026); Arabic copy is transcribed from the same document.
# Idempotent: records are looked up by slug/email and only created when missing.

admin = User.find_or_create_by!(email: "admin@milaknights.com") do |u|
  u.name = "Milaknights Admin"
  u.password = ENV.fetch("ADMIN_PASSWORD", "balhareth123")
  u.approved = true
end
puts "Admin user: #{admin.email}"

def attach_photo(record, file)
  path = Rails.root.join("public", "images", file)
  return unless File.exist?(path)

  content_type = file.end_with?(".webp") ? "image/webp" : "image/jpeg"
  record.photo.attach(io: File.open(path), filename: file, content_type: content_type)
  record.save!
end

# ── Operations (the 4 specialties) ──────────────────────────────────────────

OPERATIONS = [
  {
    slug: "knee", slug_ar: "خشونة-الركبة", category: :knee,
    title_en: "Knee Osteoarthritis", title_ar: "خشونة الركبة",
    description_en: "Knee osteoarthritis is the gradual wear of the cartilage cushioning your joint. While it is the most common cause of knee pain after 50, age does not dictate your treatment. What truly matters is the impact on your quality of life and the extent of the joint damage.",
    description_ar: "تحدث خشونة الركبة نتيجة تآكل تدريجي في الغضاريف التي تعمل كوسادة حامية لمفصلك. ورغم أنها السبب الأكثر شيوعاً لألم الركبة بعد سن الخمسين، إلا أن العمر وحده لا يحدد مسار علاجك. الأهم هو مدى تأثيرها على جودة حياتك ودرجة تضرر المفصل.",
    meta_title_en: "Knee Osteoarthritis Treatment in Riyadh — Dr. Balhareth",
    meta_description_en: "Knee osteoarthritis explained in plain language: symptoms that matter, non-surgical care, partial and total knee replacement, and when surgery is genuinely the best option.",
    landing_photo: "knee.webp", detail_photo: "cond-knee.webp",
    alt_en: "Knee osteoarthritis", alt_ar: "خشونة الركبة",
    contents: [
      {
        en: "<h3>Signs that matter</h3><p>If you recognize two or more of these symptoms, a professional assessment is your best next step.</p><ul><li>Pain while walking, using stairs, or standing up.</li><li>Morning stiffness that improves with activity.</li><li>Joint swelling following physical activity.</li><li>A grinding, clicking, or catching sensation in the joint.</li><li>Gradual difficulty in fully bending or straightening the knee.</li></ul>",
        ar: "<h3>علامات تستحق الانتباه</h3><p>إذا كنت تشعر بعرضين أو أكثر من هذه الأعراض، فمن الضروري إجراء تقييم طبي لحالتك.</p><ul><li>ألم عند المشي، صعود الدرج، أو الوقوف.</li><li>تصلب في المفصل صباحاً يتحسن مع الحركة.</li><li>تورم في المفصل بعد ممارسة أي نشاط.</li><li>الشعور باحتكاك، طقطقة، أو تعليق في حركة المفصل.</li><li>صعوبة تدريجية في ثني أو فرد الركبة بالكامل.</li></ul>"
      },
      {
        en: "<h3>Treatment options</h3><h4>Non-surgical first — always the starting point where possible</h4><ul><li>Activity modification and weight management.</li><li>Physiotherapy and muscle strengthening.</li><li>Anti-inflammatory medication.</li><li>Injections (steroid or viscosupplementation).</li></ul><h4>Surgical solutions — when conservative care is no longer enough</h4><ul><li>Arthroscopic treatment in selected cases.</li><li>Partial (unicompartmental) knee replacement.</li><li>Total knee replacement.</li><li>Revision knee replacement.</li></ul>",
        ar: "<h3>خيارات العلاج</h3><h4>الحلول غير الجراحية (نبدأ بها دائماً كلما أمكن)</h4><ul><li>تعديل الأنشطة البدنية وإدارة الوزن.</li><li>العلاج الطبيعي وتقوية العضلات.</li><li>الأدوية المضادة للالتهابات.</li><li>الحقن (الستيرويدية أو الحقن الزيتي/الزلالي).</li></ul><h4>الحلول الجراحية (عندما لا تكون الرعاية التحفظية كافية)</h4><ul><li>العلاج بالمنظار في حالات مختارة.</li><li>استبدال الركبة الجزئي (أحادي القسم).</li><li>استبدال الركبة الكلي.</li><li>جراحات تصحيح واستبدال الركبة (Revision).</li></ul>"
      },
      {
        en: "<h3>When is surgery the best option?</h3><p>Surgery is the best option when pain continues to limit your daily life despite proper conservative care — specifically when you find yourself avoiding stairs, waking up at night due to pain, or planning your entire day around the limitations of your knee. At that stage, a joint replacement reliably removes the worn surfaces, and most patients are able to walk on their new joint within just one day of surgery.</p>",
        ar: "<h3>متى تكون الجراحة هي الخيار الأمثل؟</h3><p>تصبح الجراحة هي الخيار الأفضل عندما يستمر الألم في تقييد حياتك اليومية رغم الالتزام بالرعاية التحفظية المناسبة — خاصةً عندما تضطر لتجنب صعود السلالم، أو تستيقظ ليلاً بسبب الألم، أو تجد نفسك ترتب يومك بالكامل بناءً على ما تسمح به ركبتك. في هذه المرحلة، يعمل استبدال المفصل على إزالة الأسطح التالفة بشكل موثوق، مع العلم أنه يتمكن معظم المرضى من المشي على المفصل الجديد في غضون يوم واحد فقط من الجراحة.</p>"
      }
    ],
    faqs: [
      { q_en: "How long does a knee replacement last?",
        a_en: "Modern implants typically last 20–25 years or more for most patients, thanks to significant advancements in materials and fixation techniques over the last decade.",
        q_ar: "كم تدوم عملية استبدال الركبة؟",
        a_ar: "تدوم المفاصل الحديثة عادةً لمدة 20–25 عاماً أو أكثر لدى معظم المرضى، وذلك بفضل التحسينات الكبيرة في جودة المواد وتقنيات التثبيت خلال العقد الماضي." },
      { q_en: "How soon will I walk after surgery?",
        a_en: "Most patients stand and take their first steps within 24 hours, begin walking with support within a few days, and achieve independent walking within 4–6 weeks.",
        q_ar: "متى سأتمكن من المشي بعد الجراحة؟",
        a_ar: "يتمكن معظم المرضى من الوقوف واتخاذ خطواتهم الأولى خلال 24 ساعة، ويبدأون المشي بمساعدة خلال أيام قليلة، ويستعيدون قدرتهم على المشي باستقلالية خلال 4–6 أسابيع." },
      { q_en: "Am I too young (or too old) for a replacement?",
        a_en: "There is no fixed age limit for the procedure. The decision is based on your symptoms, the extent of joint damage, and your overall health — not just your age.",
        q_ar: "هل أنا صغير (أو كبير) جداً على استبدال المفصل؟",
        a_ar: "لا يوجد عمر محدد لإجراء العملية؛ فالقرار يعتمد على شدة الأعراض، وحجم تضرر المفصل، وحالتك الصحية العامة — وليس مجرد الرقم المكتوب في بطاقة هويتك." }
    ]
  },
  {
    slug: "hip", slug_ar: "خشونة-الورك", category: :hip,
    title_en: "Hip Osteoarthritis", title_ar: "خشونة الورك",
    description_en: "Hip osteoarthritis is the wearing away of the smooth cartilage of the ball-and-socket hip joint. It typically shows up as groin pain and stiffness — and because the hip carries your whole body, it can quietly shrink your world before you notice.",
    description_ar: "تحدث خشونة الورك نتيجة تآكل الغضاريف الملساء في مفصل الورك (مفصل الكرة والتجويف). وعادة ما تظهر على شكل ألم في منطقة الفخذ وتيبس في المفصل؛ ولأن الورك يحمل وزن جسمك بالكامل، فقد تبدأ الحالة في تقييد حركتك وعالمك الخاص بصمت قبل أن تلاحظ ذلك.",
    meta_title_en: "Hip Osteoarthritis & Hip Replacement in Riyadh — Dr. Balhareth",
    meta_description_en: "Groin pain, stiffness and limping from a worn hip joint — symptoms, conservative care, and modern rapid-recovery hip replacement explained by Dr. Balhareth.",
    landing_photo: "hip.jpeg", detail_photo: "cond-hip.webp",
    alt_en: "Hip osteoarthritis", alt_ar: "خشونة الورك",
    contents: [
      {
        en: "<h3>Signs that matter</h3><p>If you recognize two or more of these symptoms, a professional assessment is your best next step.</p><ul><li>Persistent pain in the groin, thigh, or buttock, especially during movement.</li><li>Noticeable stiffness when performing daily tasks like putting on shoes or socks.</li><li>A limp that becomes more pronounced as your day progresses.</li><li>Disrupted sleep due to persistent night pain.</li><li>A gradual, month-to-month decline in your walking capacity.</li></ul>",
        ar: "<h3>علامات تستدعي الفحص</h3><p>إذا كنت تلاحظ عرضين أو أكثر مما يلي، فإن إجراء فحص سريري هو خطوتك الأكثر أهمية للحفاظ على حركتك.</p><ul><li>ألم مستمر في منطقة الفخذ أو الساق أو الأرداف، يزداد حدة مع الحركة والمشي.</li><li>تيبس يعيق مهامك اليومية البسيطة، مثل صعوبة ارتداء الحذاء أو الجوارب.</li><li>عرج يبدأ خفيفاً ويزداد وضوحاً مع نهاية يومك.</li><li>ألم ليلي مزعج يمنعك من الحصول على قسط كافٍ من الراحة.</li><li>تراجع ملحوظ في مسافة المشي التي اعتدت قطعها شهراً بعد شهر.</li></ul>"
      },
      {
        en: "<h3>Treatment options</h3><h4>Non-surgical first — always the starting point where possible</h4><ul><li>Activity modification and weight management.</li><li>Physiotherapy and hip strengthening.</li><li>Anti-inflammatory medication.</li><li>Walking aids to offload the joint.</li></ul><h4>Surgical solutions — when conservative care is no longer enough</h4><ul><li>Total hip replacement — modern bearing surfaces.</li><li>Minimally invasive approaches where suitable.</li><li>Rapid-recovery (same-week mobilization) protocols.</li><li>Revision hip replacement.</li></ul>",
        ar: "<h3>خيارات العلاج</h3><h4>الحلول غير الجراحية (نبدأ بها دائماً كلما أمكن)</h4><ul><li>تعديل الأنشطة البدنية وإدارة الوزن.</li><li>العلاج الطبيعي وتقوية عضلات الورك.</li><li>الأدوية المضادة للالتهابات.</li><li>استخدام مساعدات المشي لتخفيف الحمل على المفصل.</li></ul><h4>الحلول الجراحية (عندما لا تكون الرعاية التحفظية كافية)</h4><ul><li>استبدال مفصل الورك الكلي بأسطح مفصلية حديثة.</li><li>تقنيات التدخل الجراحي المحدود عند الحاجة.</li><li>بروتوكولات التعافي السريع (الحركة خلال نفس الأسبوع).</li><li>جراحات تصحيح واستبدال الورك (Revision).</li></ul>"
      },
      {
        en: "<h3>When is surgery the best option?</h3><p>When groin pain disrupts your sleep, your limp becomes a constant challenge, or your walking distance continues to decline despite conservative care — hip replacement stands out as one of the most successful surgical procedures available today. You can typically expect profound and rapid pain relief.</p>",
        ar: "<h3>متى تكون الجراحة هي الخيار الأمثل؟</h3><p>عندما يوقظك ألم الفخذ من نومك، أو يصبح العرج رفيقاً دائماً لحركتك، أو تستمر قدرتك على المشي في التراجع رغم التزامك بالرعاية التحفظية؛ فإن عملية استبدال مفصل الورك تظل واحدة من أنجح العمليات الجراحية في عالم الطب، حيث ستلمس عادةً تخلصاً جذرياً وسريعاً من الألم.</p>"
      }
    ],
    faqs: [
      { q_en: "How long is the hospital stay?",
        a_en: "Typically, patients stay for 1–3 nights. Most are able to stand either on the day of surgery or the following morning.",
        q_ar: "كم سأبقى في المستشفى؟",
        a_ar: "تتراوح مدة الإقامة عادةً بين ليلة واحدة إلى ثلاث ليالٍ. ويتمكن معظم المرضى من الوقوف في نفس يوم الجراحة أو في صباح اليوم التالي." },
      { q_en: "Will my legs be the same length after?",
        a_en: "Restoring both leg length and offset is a fundamental aspect of my surgical planning; precise pre-operative templating makes any significant leg length discrepancy extremely rare.",
        q_ar: "هل ستكون ساقاي بنفس الطول بعد العملية؟",
        a_ar: "تعد استعادة طول الساق والتوازن الوظيفي جزءاً أساسياً من التخطيط الجراحي الدقيق؛ حيث أن استخدام القوالب القياسية قبل الجراحة يجعل من حدوث أي تفاوت ملحوظ أمراً نادر الحدوث." },
      { q_en: "When can I drive again?",
        a_en: "Usually, you may return to driving after 4–6 weeks, once you have discontinued strong painkillers and can comfortably perform an emergency stop.",
        q_ar: "متى يمكنني القيادة مجدداً؟",
        a_ar: "عادةً بعد مرور 4–6 أسابيع، وبمجرد التوقف عن تناول المسكنات القوية والتأكد من قدرتك على تنفيذ عملية الكبح (التوقف المفاجئ) بشكل مريح وآمن." }
    ]
  },
  {
    slug: "trauma", slug_ar: "الكسور-والحوادث", category: :trauma,
    title_en: "Fractures & Trauma", title_ar: "الكسور والحوادث",
    description_en: "Fractures resulting from falls, sports, or road accidents can vary from simple breaks to complex, multi-fragment injuries, particularly around the hip and knee joints. The initial fixation is the most critical step — when performed correctly, it establishes a solid foundation for your entire recovery journey.",
    description_ar: "تتنوع الكسور الناتجة عن السقوط، أو الأنشطة الرياضية، أو حوادث الطرق بين كسور بسيطة وإصابات معقدة ومتعددة الشظايا، خاصة في المناطق المحيطة بمفصلي الورك والركبة. تظل عملية التثبيت الأولي هي الخطوة الأكثر أهمية؛ فإجراؤها بشكل دقيق يضع المسار الصحيح لرحلة تعافيك بالكامل.",
    meta_title_en: "Fracture & Trauma Surgery in Riyadh — Dr. Balhareth",
    meta_description_en: "Expert surgical care for fractures from falls and road accidents — fixation, reconstruction, staged treatment of complex injuries, and treatment of non-union.",
    landing_photo: "bone.jpeg", detail_photo: "cond-trauma.webp",
    alt_en: "Fracture and trauma surgery", alt_ar: "جراحة الكسور والحوادث",
    contents: [
      {
        en: "<h3>Signs that matter</h3><p>If you recognize two or more of these symptoms, a professional assessment is your best next step.</p><ul><li>Inability to bear weight on the limb following an injury.</li><li>Visible deformity or noticeable shortening of the affected limb.</li><li>Severe swelling and extensive bruising.</li><li>Pain that intensifies rather than subsiding after several days.</li><li>A previous fracture showing signs of failing to heal (non-union).</li></ul>",
        ar: "<h3>علامات تستدعي الفحص</h3><p>إذا كنت تلاحظ عرضين أو أكثر مما يلي، فإن إجراء فحص سريري هو خطوتك الأكثر أهمية.</p><ul><li>عدم القدرة على تحميل الوزن على الطرف المصاب بعد الإصابة.</li><li>وجود تشوه مرئي أو قصر ملحوظ في طول الطرف المصاب.</li><li>تورم حاد وكدمات واسعة النطاق.</li><li>ألم يزداد سوءاً بدلاً من أن يهدأ بعد مرور عدة أيام.</li><li>كسر سابق يظهر عليه علامات عدم الالتئام (Non-union).</li></ul>"
      },
      {
        en: "<h3>Treatment options</h3><h4>Non-surgical first — always the starting point where possible</h4><ul><li>Casting or bracing for stable, well-aligned fractures.</li><li>Close radiographic follow-up.</li><li>Early protected weight-bearing when safe.</li><li>Bone-health assessment and treatment.</li></ul><h4>Surgical solutions — when conservative care is no longer enough</h4><ul><li>Internal fixation — plates, screws, and nails.</li><li>Fracture care around existing implants.</li><li>Staged reconstruction of complex injuries.</li><li>Treatment of non-union and malunion.</li></ul>",
        ar: "<h3>خيارات العلاج</h3><h4>الحلول غير الجراحية (نبدأ بها دائماً كلما أمكن)</h4><ul><li>التجبير أو استخدام الدعامات للكسور المستقرة والمصطفة بشكل جيد.</li><li>المتابعة الدقيقة بالأشعة.</li><li>التحميل الجزئي والمحمي للوزن عند التأكد من سلامته.</li><li>تقييم وعلاج صحة العظام.</li></ul><h4>الحلول الجراحية (عندما لا تكون الرعاية التحفظية كافية)</h4><ul><li>التثبيت الداخلي — باستخدام الصفائح والمسامير والمسامير النخاعية.</li><li>علاج الكسور المحيطة بالمفاصل أو المسامير المزروعة مسبقاً.</li><li>الترميم المرحلي للإصابات المعقدة.</li><li>علاج حالات عدم الالتئام (Non-union) والالتئام الخاطئ (Malunion).</li></ul>"
      },
      {
        en: "<h3>When is surgery the best option?</h3><p>Surgery becomes the preferred option when a fracture is displaced or unstable, or when it involves a joint surface. It is also essential when early mobility is a priority — as is almost always the case with hip injuries. Modern fixation techniques allow us to mobilize patients early, which serves as the single most effective protection against potential complications.</p>",
        ar: "<h3>متى تكون الجراحة هي الخيار الأمثل؟</h3><p>تصبح الجراحة هي الخيار الأفضل عندما يكون الكسر متحركاً من مكانه (غير مصطف)، أو غير مستقر، أو عندما يشمل سطح المفصل. كما أنها ضرورية عندما تكون الحركة المبكرة أولوية، وهو الأمر الذي يمثل ضرورة قصوى دائماً في كسور الورك. تتيح لنا تقنيات التثبيت الحديثة تحريك المرضى في وقت مبكر، وهو ما يُعد أهم وسيلة وقائية على الإطلاق ضد حدوث مضاعفات.</p>"
      }
    ],
    faqs: [
      { q_en: "How long does a fracture take to heal?",
        a_en: "Most fractures typically heal within 6–12 weeks, though regaining full function requires more time. Factors such as age, bone quality, and the specific fracture pattern all play a role.",
        q_ar: "كم يستغرق التئام الكسر؟",
        a_ar: "تلتئم معظم الكسور عادةً في غضون 6–12 أسبوعاً، لكن استعادة الوظيفة الكاملة للطرف تتطلب وقتاً أطول. وتؤثر عوامل متعددة مثل العمر، وجودة العظام، ونمط الكسر على سرعة الالتئام." },
      { q_en: "Will the metal need to be removed?",
        a_en: "In most cases, this is unnecessary. Implants are only removed if they cause persistent symptoms or interfere with a future medical procedure.",
        q_ar: "هل سأحتاج إلى إزالة الأجزاء المعدنية؟",
        a_ar: "في معظم الحالات، لا حاجة لذلك. يتم إزالة هذه الأجزاء فقط إذا تسببت في ظهور أعراض مزعجة أو إذا تعارضت مع إجراء طبي مستقبلي." },
      { q_en: "I broke my hip — why is everyone rushing?",
        a_en: "Adult hip fractures require urgent treatment because early surgical intervention and rapid mobilization (walking) are critical to dramatically reducing potential complications.",
        q_ar: "لقد تعرضت لكسر في الورك — لماذا هذه العجلة في العلاج؟",
        a_ar: "تتطلب كسور الورك لدى البالغين علاجاً عاجلاً، لأن التدخل الجراحي المبكر والحركة السريعة (المشي) يعدان أمراً حيوياً للحد من المضاعفات بشكل كبير." }
    ]
  },
  {
    slug: "complex", slug_ar: "حالات-الورك-المعقدة", category: :hip,
    title_en: "Complex Hip Cases", title_ar: "حالات الورك المعقدة",
    description_en: "Some hips are anatomically different from birth or have been significantly altered by disease. Developmental dysplasia of the hip (DDH) results in a shallow socket that leads to premature wear, while sickle-cell disease can compromise blood supply to the femoral head. Such cases require a surgeon who carefully plans around the unusual anatomy — rather than merely operating through it.",
    description_ar: "بعض مشاكل الورك تكون موجودة منذ الولادة أو تنتج عن أمراض مزمنة تؤثر على طبيعة المفصل. فمثلاً، حالات مثل «خلع الورك الولادي» تجعل تجويف المفصل غير عميق، مما يسبب تآكلاً مبكراً، كما أن أمراضاً مثل «الأنيميا المنجلية» قد تؤثر على وصول الدم للعظم وتسبب تلفه. هذه الحالات تتطلب جراحاً متخصصاً يضع خطة علاجية دقيقة ومخصصة تناسب شكل المفصل الطبيعي لكل مريض، لضمان أفضل نتيجة ممكنة بعيداً عن الطرق الجراحية التقليدية الموحدة.",
    meta_title_en: "DDH & Sickle-Cell Hip Disease Treatment in Riyadh — Dr. Balhareth",
    meta_description_en: "Specialized hip reconstruction for difficult anatomy — developmental dysplasia (DDH), avascular necrosis, and sickle-cell hip disease, with 3D surgical planning.",
    landing_photo: "hip-complex.webp", detail_photo: "cond-complex.webp",
    alt_en: "Complex hip reconstruction", alt_ar: "حالات الورك المعقدة",
    contents: [
      {
        en: "<h3>Signs that matter</h3><p>If you recognize two or more of these symptoms, a professional assessment is your best next step.</p><ul><li>Hip pain beginning at an unusually young age (20s–40s).</li><li>A history of childhood hip conditions or previous brace treatment.</li><li>Sickle-cell disease accompanied by new onset of groin or hip pain.</li><li>A persistent, deep ache following periods of standing or walking.</li><li>A progressively worsening limp or a noticeable difference in leg length.</li></ul>",
        ar: "<h3>علامات تستدعي الفحص</h3><p>إذا كنت تلاحظ عرضين أو أكثر مما يلي، فإن إجراء فحص سريري هو خطوتك الأكثر أهمية.</p><ul><li>ألم في الورك يبدأ في سن مبكرة غير معتادة (من العشرينيات إلى الأربعينيات).</li><li>تاريخ مرضي معروف لحالة في الورك أثناء الطفولة أو الخضوع لعلاج بالدعامات (Brace).</li><li>الإصابة بمرض الأنيميا المنجلية (Sickle-cell disease) مع شعور بألم جديد في منطقة الفخذ أو الورك.</li><li>ألم عميق ومستمر يظهر بعد الوقوف أو المشي.</li><li>ازدياد في العرج أو ملاحظة اختلاف في طول الساقين.</li></ul>"
      },
      {
        en: "<h3>Treatment options</h3><h4>Non-surgical first — always the starting point where possible</h4><ul><li>Targeted physiotherapy and activity guidance.</li><li>Pain management and disease-specific care.</li><li>Coordination with hematology for sickle-cell patients.</li><li>Monitoring with periodic imaging.</li></ul><h4>Surgical solutions — when conservative care is no longer enough</h4><ul><li>Total hip replacement adapted to dysplastic anatomy.</li><li>Reconstruction for avascular necrosis (AVN).</li><li>Custom planning — 3D templating of the socket.</li><li>Revision of previous childhood surgery.</li></ul>",
        ar: "<h3>خيارات العلاج</h3><h4>الحلول غير الجراحية (نبدأ بها دائماً كلما أمكن)</h4><ul><li>العلاج الطبيعي الموجه وتوجيه الأنشطة البدنية.</li><li>إدارة الألم والرعاية الخاصة بالمرض.</li><li>التنسيق مع قسم أمراض الدم لمرضى الأنيميا المنجلية.</li><li>المراقبة عبر التصوير الدوري.</li></ul><h4>الحلول الجراحية (عندما لا تكون الرعاية التحفظية كافية)</h4><ul><li>استبدال مفصل الورك الكلي المتكيف مع التشريح غير الطبيعي (خلع الورك).</li><li>الترميم لحالات تنخر العظم اللاوعائي (AVN).</li><li>التخطيط المخصص — استخدام القوالب ثلاثية الأبعاد (3D) لتجويف المفصل.</li><li>إعادة جراحات سابقة أُجريت في مرحلة الطفولة.</li></ul>"
      },
      {
        en: "<h3>When is surgery the best option?</h3><p>In cases of DDH and sickle-cell hip disease, surgical timing is a matter of strategy: operating too early can compromise the implant's lifespan, while delaying too long causes the bone stock to deteriorate. The optimal time is when pain significantly limits your daily life and imaging confirms disease progression — at this point, a carefully planned reconstruction can restore the function that your anatomy never naturally provided.</p>",
        ar: "<h3>متى تكون الجراحة هي الخيار الأمثل؟</h3><p>في حالات خلع الورك الولادي (DDH) وأمراض الورك الناتجة عن الأنيميا المنجلية، يعد التوقيت استراتيجية بحد ذاته: فإجراء الجراحة مبكراً جداً قد يستنزف العمر الافتراضي للمفصل الصناعي، بينما التأخر في إجرائها يؤدي إلى تدهور المخزون العظمي. لذا، يكون الخيار الأفضل هو التدخل الجراحي عندما يبدأ الألم في تقييد حياتك اليومية وتؤكد صور الأشعة وجود تدهور في الحالة؛ ففي هذه المرحلة، يمكن لعملية ترميم مخطط لها بعناية أن تستعيد الوظائف التي لم تتوفر طبيعياً في تشريحك.</p>"
      }
    ],
    faqs: [
      { q_en: "Is hip replacement harder with DDH?",
        a_en: "It requires more extensive planning, as the socket is typically shallow and the femur is often small; however, in experienced hands, surgical outcomes are excellent.",
        q_ar: "هل عملية استبدال مفصل الورك أصعب في حالات خلع الورك الولادي (DDH)؟",
        a_ar: "تتطلب هذه الحالات تخطيطاً أكثر دقة، حيث يكون تجويف المفصل ضحلاً وعظمة الفخذ غالباً صغيرة الحجم؛ لكن مع الجراحين ذوي الخبرة، تكون النتائج الجراحية ممتازة." },
      { q_en: "I have sickle-cell disease. Is surgery safe for me?",
        a_en: "Yes, it is safe with the right preparation. We coordinate closely with the hematology team before, during, and after surgery to manage the condition safely.",
        q_ar: "أنا مصاب بالأنيميا المنجلية، هل الجراحة آمنة بالنسبة لي؟",
        a_ar: "نعم، الجراحة آمنة مع التحضير الجيد. نحن ننسق بشكل وثيق مع قسم أمراض الدم قبل الجراحة وأثناءها وبعدها لإدارة الحالة بسلامة." },
      { q_en: "Can AVN be treated without a replacement?",
        a_en: "In the early stages, it is sometimes possible; a procedure called core decompression can be helpful. However, once the femoral head has collapsed, hip replacement becomes the most reliable solution.",
        q_ar: "هل يمكن علاج تنخر العظم (AVN) دون الحاجة لاستبدال المفصل؟",
        a_ar: "في المراحل المبكرة، يكون ذلك ممكناً أحياناً؛ حيث يمكن أن يساعد إجراء يُعرف بـ «تخفيف الضغط الأساسي» (Core decompression). أما بمجرد انهيار رأس عظمة الفخذ، يصبح استبدال المفصل هو الحل الأكثر موثوقية." }
    ]
  }
].freeze

OPERATIONS.each do |data|
  operation = Operation.find_by(slug: data[:slug])
  if operation.nil?
    operation = Operation.create!(
      slug: data[:slug], slug_ar: data[:slug_ar], category: data[:category],
      title_en: data[:title_en], title_ar: data[:title_ar],
      description_en: data[:description_en], description_ar: data[:description_ar],
      meta_title_en: data[:meta_title_en], meta_title_ar: data[:title_ar],
      meta_description_en: data[:meta_description_en], meta_description_ar: data[:description_ar],
      image_alt_text_en: data[:alt_en], image_alt_text_ar: data[:alt_ar],
      is_published: true, user_id: admin.id
    )

    landing = operation.operation_photos.create!(alt_en: data[:alt_en], alt_ar: data[:alt_ar], is_landing: true)
    attach_photo(landing, data[:landing_photo])
    detail = operation.operation_photos.create!(alt_en: data[:alt_en], alt_ar: data[:alt_ar], is_landing: false)
    attach_photo(detail, data[:detail_photo])

    data[:contents].each do |c|
      operation.contents.create!(content_en: c[:en], content_ar: c[:ar], is_published: true, user_id: admin.id)
    end
    data[:faqs].each do |f|
      operation.faqs.create!(question_en: f[:q_en], answer_en: f[:a_en], question_ar: f[:q_ar], answer_ar: f[:a_ar], is_published: true, user_id: admin.id)
    end
    puts "Operation created: #{operation.title_en}"
  else
    puts "Operation exists:  #{operation.title_en}"
  end
end

# ── Global FAQs (the /faq page) ─────────────────────────────────────────────

GLOBAL_FAQS = [
  ["Do I need a referral to book an appointment?",
   "No, you can book directly via our website form, by phone, or on WhatsApp. If you already have a referral or previous medical reports, please bring them along as they are very helpful.",
   "هل أحتاج إلى تحويل طبي لحجز موعد؟",
   "لا، يمكنك الحجز مباشرة عبر نموذج الموقع الإلكتروني، أو الهاتف، أو واتساب. وإذا كان لديك تحويل طبي أو تقارير سابقة، يُفضل إحضارها معك فهي تساعدنا كثيراً."],
  ["What should I bring to my first consultation?",
   "Please bring any X-rays, MRI scans, or medical reports you have, a list of your current medications, and your insurance card if applicable. If you do not have any imaging, we can arrange for it during your visit.",
   "ما الذي يجب أن أحضره معي إلى الاستشارة الأولى؟",
   "يُرجى إحضار أي صور أشعة، أو رنين مغناطيسي، أو تقارير طبية لديك، بالإضافة إلى قائمة بالأدوية التي تتناولها، وبطاقتك التأمينية إن وجدت. وفي حال عدم توفر صور أشعة، يمكننا ترتيب ذلك خلال زيارتك."],
  ["Is the clinic covered by insurance?",
   "The clinic works with most major Saudi insurance providers. Simply contact us with your policy details, and we will confirm your coverage prior to your visit.",
   "هل تغطي العيادة خدمات التأمين؟",
   "تعمل العيادة مع معظم مزودي التأمين الرئيسيين في المملكة العربية السعودية. ما عليك سوى التواصل معنا وتزويدنا بتفاصيل بوليصتك، وسنقوم بتأكيد التغطية قبل موعد زيارتك."],
  ["How fast can I get an appointment?",
   "Routine appointments are typically available within a few days. Urgent cases, such as fractures or severe pain, are treated as a priority and are often seen on the same or the following day.",
   "ما مدى سرعة الحصول على موعد؟",
   "تتوفر المواعيد الروتينية عادةً في غضون أيام قليلة. أما الحالات العاجلة — كالكسور أو الآلام الشديدة — فتُعامل كأولوية، وغالباً ما يتم استقبالها في نفس اليوم أو اليوم التالي."],
  ["How long does joint replacement surgery take?",
   "Typically, the procedure lasts 1–2 hours in the operating theatre. Including time in anesthesia and the recovery room, you should expect to be away from your hospital room for about half a day.",
   "كم تستغرق عملية استبدال المفصل؟",
   "تستغرق العملية عادةً من ساعة إلى ساعتين داخل غرفة العمليات. ومع احتساب وقت التخدير والإقامة في غرفة الإفاقة، توقع أن تكون خارج غرفتك لمدة نصف يوم تقريباً."],
  ["What type of anesthesia is used?",
   "Most joint replacements are performed under spinal anesthesia combined with sedation. This ensures you feel nothing during the procedure and typically allows for a faster recovery compared to general anesthesia. Our anesthesia team will discuss the best option for your specific needs.",
   "ما نوع التخدير المستخدم؟",
   "تُجرى معظم عمليات استبدال المفاصل تحت التخدير النصفي (النخاعي) مع مهدئ؛ مما يضمن عدم شعورك بأي شيء خلال العملية، كما يتيح لك تعافياً أسرع مقارنة بالتخدير العام. سيقوم فريق التخدير بمناقشة الخيار الأنسب لحالتك معك."],
  ["How long will my new joint last?",
   "Modern implants typically last 20–25 years or more for most patients, as both materials and surgical techniques have improved substantially over the last decade.",
   "كم سيدوم مفصلي الجديد؟",
   "تدوم المفاصل الحديثة عادةً لمدة 20–25 عاماً أو أكثر لدى معظم المرضى، وذلك بفضل التحسينات الكبيرة في جودة المواد والتقنيات الجراحية خلال العقد الماضي."],
  ["Am I too old (or too young) for a replacement?",
   "There is no fixed age limit for this procedure. The decision is based on your symptoms, the extent of joint damage, and your overall health — not just the number on your ID.",
   "هل أنا كبير (أو صغير) جداً على إجراء الاستبدال؟",
   "لا يوجد عمر محدد لإجراء هذه العملية؛ فالقرار يعتمد على شدة الأعراض، وحجم تضرر المفصل، وحالتك الصحية العامة — وليس مجرد الرقم المكتوب في هويتك."],
  ["When will I walk after joint replacement?",
   "Most patients are able to stand and take their first steps within 24 hours of surgery. They typically progress to walking with support within a few days, and achieve independent walking within 4–6 weeks.",
   "متى سأتمكن من المشي بعد استبدال المفصل؟",
   "يتمكن معظم المرضى من الوقوف واتخاذ خطواتهم الأولى خلال 24 ساعة من الجراحة. ثم يتقدمون للمشي باستخدام دعم خلال بضعة أيام، ويصلون إلى المشي بشكل مستقل تماماً في غضون 4–6 أسابيع."],
  ["How long is the hospital stay?",
   "Typically, patients stay for 1–3 nights for a joint replacement. For fracture surgery, the duration varies depending on the specific injury.",
   "كم سأبقى في المستشفى؟",
   "عادةً ما تتراوح مدة الإقامة بين ليلة واحدة إلى 3 ليالٍ في حالات استبدال المفاصل. أما في جراحات الكسور، فتختلف المدة باختلاف طبيعة الإصابة."],
  ["When can I drive again?",
   "Usually, you may return to driving after 4–6 weeks, once you have discontinued strong painkillers and can comfortably perform an emergency stop.",
   "متى يمكنني القيادة مجدداً؟",
   "عادةً بعد مرور 4–6 أسابيع، وبمجرد التوقف عن تناول المسكنات القوية والتأكد من قدرتك على تنفيذ عملية الكبح (التوقف المفاجئ) بشكل مريح."],
  ["Will I need physiotherapy?",
   "Yes — structured rehabilitation is half the result. You will leave the hospital with a clear, personalized program, and we will closely monitor your progress during every review visit.",
   "هل سأحتاج إلى علاج طبيعي؟",
   "نعم، فالتأهيل المنظم يمثل نصف النتيجة. ستغادر المستشفى ببرنامج علاجي واضح، وسنتابع مدى تطور حالتك بدقة خلال كل زيارة للمراجعة."]
].freeze

GLOBAL_FAQS.each do |q_en, a_en, q_ar, a_ar|
  next if Faq.global.exists?(question_en: q_en)

  Faq.create!(question_en: q_en, answer_en: a_en, question_ar: q_ar, answer_ar: a_ar,
              is_published: true, user_id: admin.id)
end
puts "Global FAQs: #{Faq.global.count}"

# ── Draft blogs (from the design; unpublished until the client approves) ────

DRAFT_BLOGS = [
  ["when-is-knee-replacement-the-right-choice", "متى-يكون-استبدال-الركبة-الخيار-الصحيح", :knee,
   "When is knee replacement the right choice?", "متى يكون استبدال الركبة هو الخيار الصحيح؟",
   "The honest checklist we use in clinic before recommending surgery.", "قائمة التقييم الصادقة التي نستخدمها في العيادة قبل التوصية بالجراحة.", "blog1.webp"],
  ["hip-pain-five-warning-signs", "ألم-الورك-خمس-علامات-تحذيرية", :hip,
   "Hip pain: five warning signs you shouldn't ignore", "ألم الورك: خمس علامات تحذيرية لا تتجاهلها",
   "Groin pain, night pain, limping — what each one usually means.", "ألم الفخذ، الألم الليلي، العرج — ماذا تعني كل علامة عادةً.", "blog2.webp"],
  ["recovering-after-a-fracture", "التعافي-بعد-الكسر", :recovery,
   "Recovering after a fracture: what to expect", "التعافي بعد الكسر: ماذا تتوقع",
   "A week-by-week map from surgery to full weight-bearing.", "خريطة أسبوعاً بأسبوع من الجراحة حتى التحميل الكامل للوزن.", "blog3.webp"],
  ["partial-vs-total-knee-replacement", "الاستبدال-الجزئي-مقابل-الكلي-للركبة", :knee,
   "Partial vs. total knee replacement — the real difference", "الاستبدال الجزئي مقابل الكلي للركبة — الفرق الحقيقي",
   "Who qualifies for the smaller operation, and why it matters.", "من هو المؤهل للعملية الأصغر، ولماذا يعد ذلك مهماً.", "blog4.webp"],
  ["living-with-ddh-as-an-adult", "التعايش-مع-خلع-الورك-الولادي-للبالغين", :hip,
   "Living with DDH as an adult: your options", "التعايش مع خلع الورك الولادي للبالغين: خياراتك",
   "Why dysplasia causes early arthritis — and how we treat it.", "لماذا يسبب خلع الورك الولادي خشونة مبكرة — وكيف نعالجه.", "blog5.webp"],
  ["what-to-bring-to-your-first-consultation", "ماذا-تحضر-إلى-استشارتك-الأولى", :general,
   "What to bring to your first consultation", "ماذا تُحضر إلى استشارتك الأولى",
   "Scans, reports, and the three questions worth writing down.", "الأشعة والتقارير والأسئلة الثلاثة التي تستحق التدوين.", "story.jpeg"]
].freeze

DRAFT_BLOGS.each do |slug, slug_ar, category, title_en, title_ar, desc_en, desc_ar, photo_file|
  next if Blog.exists?(slug: slug)

  blog = Blog.create!(
    slug: slug, slug_ar: slug_ar, category: category,
    title_en: title_en, title_ar: title_ar,
    description_en: desc_en, description_ar: desc_ar,
    meta_title_en: title_en, meta_title_ar: title_ar,
    meta_description_en: desc_en, meta_description_ar: desc_ar,
    is_published: false, user_id: admin.id
  )
  photo = blog.blog_photos.create!(alt_en: title_en, alt_ar: title_ar, is_arabic: false)
  attach_photo(photo, photo_file)
  puts "Draft blog created: #{title_en}"
end

puts "Seed complete: #{Operation.count} operations, #{Faq.count} FAQs, #{Blog.count} blogs (#{Blog.published.count} published)."
