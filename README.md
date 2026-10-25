# Laura Riera Alonso | Portfolio de IA y salud

Ingeniera biomédica (UC3M) con experiencia en **Python, SQL y PostgreSQL, ETL de datos clínicos y deep learning**. Este repositorio documenta mis dos proyectos principales de IA aplicada a salud: el Trabajo Fin de Grado y el Trabajo Fin de Máster.

Madrid · [LinkedIn](https://www.linkedin.com/in/laura-riera-alonso-b60299251) · lrieralonso@gmail.com

**Herramientas que se usan aquí:** Python · SQL y PostgreSQL · ETL sobre historia clínica electrónica · CIE-10 (ICD-10) · PyTorch · scikit-learn · Power BI · trabajo con datos seudonimizados y protección de datos · Git

## Proyectos

| Proyecto | Resumen | Tecnologías |
|---|---|---|
| [**TFG · RM sintética con contraste**](tfg/README.md) | Red U-Net que genera la resonancia T1 con gadolinio a partir de secuencias sin contraste en pacientes con glioma, validada con un radiólogo | Python, PyTorch, fastai, Nipype, FSL, ANTs, MATLAB |
| [**TFM · Riesgo de insuficiencia renal en diabetes tipo 1**](tfm/README.md) | Proyecto en equipo: cohorte de 2.220 pacientes de MIMIC-IV en PostgreSQL, ETL clínico en Python sobre datos de historia clínica electrónica, modelo Lasso (AUC 0,83) y priorización por riesgo, que llevamos a un [cuadro de mando en Power BI](#cuadro-de-mando-del-tfm) | PostgreSQL, SQL, Python, CIE-10 (ICD-9/10), scikit-learn, R (tidymodels, código no incluido aquí), Power BI |

### Cuadro de mando del TFM

El modelo alimenta un cuadro de mando en Power BI que caracteriza la cohorte y prioriza a los
pacientes por decil de riesgo de insuficiencia renal.

![Caracterización de la cohorte](tfm/docs/TFM_CuadroMandos_Resumen.png)

Con el modelo se puede concentrar el seguimiento en el 10 % de pacientes con más riesgo y capturar
ahí el 92 % de los casos, frente al 31 % que daría un seguimiento aleatorio del mismo tamaño.

![Simulación de impacto asistencial](tfm/docs/TFM_CuadroMandos_SimulacionClinica.png)

Solo se publican las vistas agregadas. Las de paciente individual no se incluyen porque muestran
registros de MIMIC-IV, y su licencia de acceso prohíbe redistribuir los datos.

## Qué mirar primero

Si tienes poco tiempo, estos tres archivos dan una idea del trabajo:

- [Cohorte de diabetes tipo 1 en SQL](tfm/sql/mimi_diabetic_schema.sql): cómo se selecciona la cohorte en PostgreSQL a partir de códigos CIE-10 (ICD-9 e ICD-10) de la historia clínica.
- [Selección de cohorte y limpieza de datos clínicos](tfm/notebooks/01_seleccion_cohorte_postgres.ipynb): el ETL, con los criterios de inclusión y exclusión, en Python sobre PostgreSQL.
- [Preprocesado de neuroimagen](tfg/src/02_preprocesado/01_preprocesado_estructural.ipynb): el flujo de preparación de las resonancias del TFG.

## Cómo trabajo

- **Datos clínicos con responsabilidad.** Trabajo con datos seudonimizados, normativa de protección de datos y control de calidad documentado. En este repositorio no hay datos de pacientes.
- **Pipelines documentados paso a paso.** Cada fase está separada y descrita en el README de su proyecto. Sin los datos clínicos, que no se pueden compartir, no se pueden ejecutar de principio a fin.
- **Decisiones con el usuario clínico.** En el TFG, el modelo final se eligió con el criterio del radiólogo, no solo por la métrica más alta.
- **Honestidad con los resultados.** Cada proyecto incluye limitaciones y qué no consigue.

## Experiencia profesional

**Project Specialist, Government Affairs · AbbVie España (feb 2026 a la actualidad).** Coordino proyectos transversales con la Administración, hospitales y socios externos, y desarrollo herramientas propias para darles seguimiento.

- Desarrollo desde cero de una aplicación web en Python y SQLite para gestionar la logística de reuniones con terceros (participantes, viajes, tareas, aprobaciones y alertas), con importación desde Excel y Outlook y pensada para reutilizarse en otros proyectos. Es un prototipo local de uso interno, no un despliegue corporativo.
- Coordinación de la candidatura de la compañía a un programa nacional de reconocimiento de la capacidad de I+D e industrial del sector farmacéutico: 10 departamentos y una consultora externa, con criterios de dato comunes y una fuente única y trazable para cada cifra, hasta su presentación ante el Ministerio.
- Coordinación de un proyecto de sostenibilidad en farmacia hospitalaria, junto a una organización ambiental y dentro de una iniciativa sectorial, para medir y reducir la huella de carbono de la logística del medicamento, con hospitales piloto y un comité de expertos.

**Analista de Business Excellence · AbbVie España (feb 2025 a feb 2026).** Trabajé en analítica de negocio dentro de una farmacéutica multinacional, automatizando informes y cuadros de mando con Power BI. Esta experiencia complementa los proyectos académicos con el uso de cuadros de mando en un entorno de empresa.
