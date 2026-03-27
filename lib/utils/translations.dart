enum AppLanguage { en, pt }

class AppStrings {
  static const Map<AppLanguage, Map<String, String>> values = {
    AppLanguage.en: {
      'appTitle': 'ReUse',
      'subtitle': 'Take a photo of a used item and get a better sustainable action.',
      'chooseImage': 'Choose Image',
      'takePhoto': 'Take Photo',
      'analyzeObject': 'Analyze Object',
      'recommendedAction': 'Recommended Action',
      'reuseIdeas': 'Reuse Ideas',
      'recyclingTip': 'Recycling Tip',
      'aiConfidence': 'AI Confidence',
      'condition': 'Condition',
      'explanation': 'Explanation',
      'readyToScan': 'Ready to scan',
      'noImageSelected': 'No image selected yet',
      'selectedImage': 'Selected image',
      'objectName': 'Object',
      'errorTitle': 'Something went wrong',
      'tryAgain': 'Please try again.',
      'analysisResult': 'Analysis Result',
      'language': 'Language',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'emptyStateTitle': 'Start your scan',
      'emptyStateSubtitle': 'Pick an image or take a photo to analyze a used object.',
      'loadingText': 'Analyzing image...',
      'scanSummary': 'Scan Summary',
      'analysisOverview': 'Analysis overview',
      'confidenceScore': 'Confidence score',
      'whyThisDecision': 'Why this decision',
      'nextBestUse': 'Next best use',
      'imageReady': 'Your selected item is ready for analysis.',
      'smartSuggestion': 'Smart sustainable suggestion',
      'scanUsedObject': 'Scan a used object',
      'decisionReuse': 'Reuse',
      'decisionRepair': 'Repair',
      'decisionRecycle': 'Recycle',
      'decisionDonate': 'Donate',
      'decisionDispose': 'Dispose',
    },
    AppLanguage.pt: {
      'appTitle': 'ReUse',
      'subtitle': 'Tire uma foto de um item usado e receba a melhor ação sustentável.',
      'chooseImage': 'Escolher imagem',
      'takePhoto': 'Tirar foto',
      'analyzeObject': 'Analisar objeto',
      'recommendedAction': 'Ação recomendada',
      'reuseIdeas': 'Ideias de reutilização',
      'recyclingTip': 'Dica de reciclagem',
      'aiConfidence': 'Confiança da IA',
      'condition': 'Condição',
      'explanation': 'Explicação',
      'readyToScan': 'Pronto para escanear',
      'noImageSelected': 'Nenhuma imagem selecionada ainda',
      'selectedImage': 'Imagem selecionada',
      'objectName': 'Objeto',
      'errorTitle': 'Algo deu errado',
      'tryAgain': 'Tente novamente.',
      'analysisResult': 'Resultado da análise',
      'language': 'Idioma',
      'high': 'Alta',
      'medium': 'Média',
      'low': 'Baixa',
      'emptyStateTitle': 'Comece sua análise',
      'emptyStateSubtitle': 'Escolha uma imagem ou tire uma foto para analisar um objeto usado.',
      'loadingText': 'Analisando imagem...',
      'scanSummary': 'Resumo da análise',
      'analysisOverview': 'Visão geral da análise',
      'confidenceScore': 'Nível de confiança',
      'whyThisDecision': 'Por que essa decisão',
      'nextBestUse': 'Melhor próximo uso',
      'imageReady': 'Seu item selecionado está pronto para análise.',
      'smartSuggestion': 'Sugestão sustentável inteligente',
      'scanUsedObject': 'Analise um objeto usado',
      'decisionReuse': 'Reutilizar',
      'decisionRepair': 'Reparar',
      'decisionRecycle': 'Reciclar',
      'decisionDonate': 'Doar',
      'decisionDispose': 'Descartar',
    },
  };

  static String t(AppLanguage language, String key) {
    return values[language]?[key] ?? key;
  }
}

class BackendTranslator {
  static final Map<String, String> decisionPt = {
    'reuse': 'reutilizar',
    'repair': 'reparar',
    'recycle': 'reciclar',
    'donate': 'doar',
    'dispose': 'descartar',
  };

  static final Map<String, String> objectPt = {
    't-shirt': 'camiseta',
    'shirt': 'camisa',
    'bottle': 'garrafa',
    'paper': 'papel',
    'cardboard': 'papelão',
    'plastic container': 'recipiente plástico',
    'shoe': 'sapato',
  };

  static final Map<String, String> conditionPt = {
    'new': 'novo',
    'good': 'bom',
    'worn': 'gasto',
    'raggedy': 'muito desgastado',
    'damaged': 'danificado',
    'torn': 'rasgado',
    'worn, torn': 'gasto e rasgado',
  };

  static final Map<String, String> fullTextPt = {
    'Due to its damaged condition, this shirt is better suited for repurposing than regular use.':
        'Devido ao seu estado danificado, esta peça é mais adequada para reaproveitamento do que para uso normal.',
    'use it as a cleaning rag': 'use como pano de limpeza',
    'turn it into a reusable bag': 'transforme em uma bolsa reutilizável',
    'upcycle it into a unique item': 'faça um reaproveitamento criativo em um novo item',
  };

  static String translateValue({
    required String value,
    required AppLanguage language,
    Map<String, String>? customMap,
  }) {
    if (language == AppLanguage.en) return value;
    if (value.trim().isEmpty) return value;

    if (customMap != null && customMap.containsKey(value)) {
      return customMap[value]!;
    }

    if (fullTextPt.containsKey(value)) {
      return fullTextPt[value]!;
    }

    return value;
  }
}