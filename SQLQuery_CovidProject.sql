-- CovidDeath Data

 SELECT *
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 ORDER BY 3,4

-- CovidVaccinations Data

 SELECT *
 FROM CovidProject..CovidVaccinations

 -- Main columns of CovidDeath Data

 SELECT location, date, total_cases, new_cases, total_deaths, population
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 ORDER BY 1,2

 -- Deaths Percentage

 SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases), 3)*100 AS Death_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 ORDER BY 1,2

 -- Deaths Percentage in Russia

 SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases), 3)*100 AS Death_percentage
 FROM CovidProject..CovidDeaths
 WHERE location = 'Russia'
 AND continent is not NULL
 ORDER BY 1,2

 -- Percentage of population got Covid

 SELECT location, date, total_cases, population, ROUND((total_cases/population), 5)*100 AS cases_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 ORDER BY 1,2

 -- Percentage of population in Russia got Covid

 SELECT location, date, total_cases, population, ROUND((total_cases/population), 5)*100 AS cases_percentage
 FROM CovidProject..CovidDeaths
 WHERE location = 'Russia'
 AND continent is not NULL
 ORDER BY 1,2

 -- Countries with highest infection rate

 SELECT location, MAX(ROUND((total_cases/population), 5)*100) AS cases_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 GROUP BY location
 ORDER BY cases_percentage DESC

 -- Total Deaths in countries

 SELECT location, MAX(CAST(total_deaths AS INT)) AS total_deaths
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 GROUP BY location
 ORDER BY total_deaths DESC

  -- Total Deaths in continents

 SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_deaths
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 GROUP BY continent
 ORDER BY total_deaths DESC

  -- Countries with highest death count per population

 SELECT location, MAX(ROUND((total_deaths/population), 5)*100) AS deaths_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 GROUP BY location
 ORDER BY deaths_percentage DESC

-- Continents with highest death count per population

 SELECT continent, MAX(ROUND((total_deaths/population), 5)*100) AS deaths_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 GROUP BY continent
 ORDER BY deaths_percentage DESC

-- New cases and deaths by date

 SELECT date, SUM(new_cases) AS total_new_cases, 
              SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
			  ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100,2) AS deaths_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 GROUP BY date
 ORDER BY 1,2

 -- Total new cases and deaths

 SELECT SUM(new_cases) AS total_new_cases, 
        SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
	    ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100,2) AS deaths_percentage
 FROM CovidProject..CovidDeaths
 WHERE continent is not NULL
 ORDER BY 1,2

-- Total people vaccinated in world

 SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
 FROM CovidProject..CovidVaccinations AS v
 JOIN CovidProject..CovidDeaths AS d
 ON v.location = d.location
 AND v.date = d.date
  WHERE d.continent is not NULL
 ORDER BY 1,2,3

 -- Total people vaccinated in world and total vaccinations by location

 SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
        SUM(CAST(v.new_vaccinations AS INT)) 
		OVER (PARTITION BY d.location
		      ORDER BY d.location, d.date) AS total_vaccinations,
			  (total_vaccinations/d.population)*100
 FROM CovidProject..CovidVaccinations AS v
 JOIN CovidProject..CovidDeaths AS d
 ON v.location = d.location
 AND v.date = d.date
 WHERE d.continent is not NULL
 ORDER BY 1,2,3


-- Store Datafor visualizations

CREATE View PercentPopulationVaccinated AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
        SUM(CAST(v.new_vaccinations AS INT)) 
		OVER (PARTITION BY d.location
		      ORDER BY d.location, d.date) AS total_vaccinations
 FROM CovidProject..CovidVaccinations AS v
 JOIN CovidProject..CovidDeaths AS d
 ON v.location = d.location
 AND v.date = d.date
 WHERE d.continent is not NULL


 SELECT *
 FROM PercentPopulationVaccinated