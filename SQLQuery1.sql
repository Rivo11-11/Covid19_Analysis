-- Excel Deaths

-- Death percentage
--SELECT Location , date , total_cases,total_deaths,(total_deaths/total_cases) * 100 as death_percentage
--  FROM [Portofolio Project]..CovidDeaths$
--  WHERE location = "Egypt"
--  order by 1,2

-- Infected Percentage
 --SELECT Location , date , population,total_cases,(total_cases/population) * 100 as Infected_percentage
 -- FROM [Portofolio Project]..CovidDeaths$
 -- WHERE location = 'Egypt'
 -- order by 1,2


  -- Country  most infected percentage
  --SELECT Location ,  population,MAX(total_cases)as total_cases , MAX((total_cases/population) * 100 )as Infected_percentage
  --FROM [Portofolio Project]..CovidDeaths$
  --GROUP BY Location ,  population
  --ORDER BY 4 desc

    -- Country that has the most deaths
  --SELECT Location ,  population,MAX(cast(total_deaths as int))as total_death , MAX(total_deaths)/MAX(total_cases) * 100 as death_percentage
  --FROM [Portofolio Project]..CovidDeaths$
  --WHERE continent is not null
  --GROUP BY Location ,  population
  --ORDER BY total_death desc

  -- Continent that has the most cases
  --SELECT location,MAX(cast(total_cases as int)) as total_cases , MAX((total_cases/population) * 100 )as Infected_percentage
  --FROM [Portofolio Project]..CovidDeaths$
  --WHERE continent is  null
  --GROUP BY location
  --ORDER BY 2 desc

  -- Showing continent with the highest death
  -- SELECT continent,MAX(cast(total_deaths as int)) as total_deaths , MAX((total_cases/population) * 100 )as Infected_percentage
  --FROM [Portofolio Project]..CovidDeaths$
  --WHERE continent is  not null
  --GROUP BY continent
  --ORDER BY 2 desc

  -- Global numbers by date 
  --SELECT date ,SUM(new_cases) as new_cases ,SUM(cast(new_deaths as int)) as new_deaths
  --FROM [Portofolio Project]..CovidDeaths$
  --WHERE continent is  not null
  --GROUP BY date
  --ORDER BY 1


  -- Excel vaccines

  -- Looking total population vs Vaccinations
  -- we could make with total vacination but we used partition to use only the new_vaccinated col
  --
  --notice the the new_count does not consider the initialization of the total_vac .. 
  --so at the end the count_vaccinated will equal total_vac - initialization

 WITH PopVsVac(Continent, location, date, population, new_vaccination, count_vaccination) AS (
  SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location, dea.date ) as count_vaccinated
  FROM [Portofolio Project]..CovidVaccinations$ vac JOIN
    [Portofolio Project]..CovidDeaths$ dea
    ON dea.location = vac.location
    and dea.date = vac.date
  WHERE dea.continent is not null
);

--CREATE VIEW MostVaccinatedCountry AS
SELECT Continent, location, population, MAX(count_vaccination) AS total_vaccinated,
MAX(count_vaccination) / population * 100 AS percentage_vaccinated
FROM PopVsVac
GROUP BY Continent, location, population
ORDER BY 4 DESC;




  -- next we want to use the max count_vaccinated number of a population (until 30-4-21) compare to it
  --  we want to use the last value of the count_vaccinated for each location and divided by population
  -- we will create a cte or a temp table