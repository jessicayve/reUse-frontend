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
      'decision': 'Decision',
      'confidence': 'Confidence',
      'analyzing': 'Analyzing...',
      'scanDescription':
          'Scan a used item and get the best sustainable action.',
      'uploadHint': 'Upload or take a photo of a used item.',
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
      'emptyStateSubtitle':
          'Escolha uma imagem ou tire uma foto para analisar um objeto usado.',
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
      'decision': 'Decisão',
      'confidence': 'Confiança',
      'analyzing': 'Analisando...',
      'scanDescription':
          'Escaneie um item usado e receba a melhor ação sustentável.',
      'uploadHint': 'Envie ou tire uma foto de um item usado.',
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
    'due to its damaged condition, this shirt is better suited for repurposing than regular use':
        'Devido ao seu estado danificado, esta peça é mais adequada para reaproveitamento do que para uso normal.',
    'use it as a cleaning rag': 'Use como pano de limpeza',
    'turn it into a reusable bag': 'Transforme em uma bolsa reutilizável',
    'upcycle it into a unique item':
        'Faça um reaproveitamento criativo em um novo item',
    'the fabric is torn but can be mended for extended use':
        'O tecido está rasgado, mas pode ser consertado para continuar sendo usado.',
    'patch the holes with decorative fabric':
        'Cubra os furos com tecido decorativo',
    'cut into cleaning rags': 'Corte em panos de limpeza',
    'use for craft projects': 'Use em projetos de artesanato',
    'turn into plant pot holders': 'Transforme em suporte para vasos de plantas',
    'too damaged to wear but can be repurposed':
        'Está danificado demais para vestir, mas pode ser reaproveitado.',
    "don't throw it in regular trash, check the recycling bin, collection point or local rules to recycle it properly":
        'Não jogue no lixo comum; verifique a coleta seletiva, um ponto de descarte ou as regras locais para reciclar corretamente.',
  };

  static String _normalize(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[.!?]+$'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static String translateValue({
    required String value,
    required AppLanguage language,
    Map<String, String>? customMap,
  }) {
    if (language == AppLanguage.en) return value;
    if (value.trim().isEmpty) return value;

    final normalizedValue = _normalize(value);

    if (customMap != null) {
      for (final entry in customMap.entries) {
        if (_normalize(entry.key) == normalizedValue) {
          return entry.value;
        }
      }
    }

    for (final entry in fullTextPt.entries) {
      if (_normalize(entry.key) == normalizedValue) {
        return entry.value;
      }
    }

    if (normalizedValue.contains('damaged') &&
        normalizedValue.contains('repurpos')) {
      return 'Devido ao estado danificado, este item é mais adequado para reaproveitamento.';
    }

    if (normalizedValue.contains('damaged') &&
        normalizedValue.contains('wear')) {
      return 'Está danificado demais para uso normal, mas ainda pode ser reaproveitado.';
    }

    if (normalizedValue.contains('fabric') &&
        normalizedValue.contains('torn')) {
      return 'O tecido está rasgado, mas pode ser consertado para continuar em uso.';
    }

    if (normalizedValue.contains('cleaning rag') ||
        normalizedValue.contains('cleaning rags')) {
      return 'Use como pano de limpeza';
    }

    if (normalizedValue.contains('reusable bag')) {
      return 'Transforme em uma bolsa reutilizável';
    }

    if (normalizedValue.contains('upcycle')) {
      return 'Reaproveite de forma criativa em um novo item';
    }

    if (normalizedValue.contains('craft project')) {
      return 'Use em projetos de artesanato';
    }

    if (normalizedValue.contains('plant pot holders')) {
      return 'Transforme em suporte para vasos de plantas';
    }

    if (normalizedValue.contains('recycling bin') ||
        normalizedValue.contains('collection point')) {
      return 'Não jogue no lixo comum; procure a coleta seletiva ou um ponto de descarte adequado.';
    }

    return value;
  }

  static List<String> translateList({
    required List<String> items,
    required AppLanguage language,
  }) {
    return items
        .map((item) => translateValue(value: item, language: language))
        .toList();
  }
}